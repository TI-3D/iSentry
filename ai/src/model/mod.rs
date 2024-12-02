use std::{env::var, path::PathBuf, sync::Arc, time::Duration};

use ab_glyph::{FontRef, PxScale};
use bounding_box::BoundingBox;
// use chrono::Utc;
use crate::utils::LabelID;
use dlib_face_recognition::{
    FaceDetector, FaceDetectorTrait, FaceEncoderNetwork, FaceEncoderTrait, FaceLandmarks,
    ImageMatrix, LandmarkPredictor, LandmarkPredictorTrait,
};
use identity::{Faces, Identities};
use image::DynamicImage;
use mysql::{params, prelude::Queryable};
use tokio::{
    sync::{mpsc::Receiver, Mutex},
    time::sleep,
};
use uuid::Uuid;

use crate::job::{Job, JobKind, JobResult};

pub mod bounding_box;
pub mod example;
mod face_detection;
mod identity;

pub async fn run(db_pool: mysql::Pool, mut rx: Receiver<Job>) {
    let detector = FaceDetector::default();
    let Ok(landmark_predictor) = LandmarkPredictor::default() else {
        panic!("Error loading Landmark Predictor.");
    };
    let Ok(face_encoder) = FaceEncoderNetwork::default() else {
        panic!("Error loading Face Encoder.");
    };

    let mut db_conn = db_pool.get_conn().unwrap();

    let faces = Arc::new(Mutex::new(Faces::default()));
    let identities = Arc::new(Mutex::new(Identities::default()));

    let faces_clone = faces.clone();
    let identities_clone = identities.clone();

    tokio::spawn(async move {
        loop {
            match db_pool.get_conn() {
                Ok(mut db_conn) => {
                    let mut faces = faces_clone.lock().await;
                    let mut identities = identities_clone.lock().await;

                    if let Err(e) = identity::update(db_conn.as_mut(), &mut faces, &mut identities)
                    {
                        tracing::error!("Error updating identity: {e}");
                    }
                }
                Err(e) => tracing::error!("Failed to get database connection through pool: {e}"),
            }
            sleep(Duration::from_secs(60)).await
        }
    });

    while let Some(job) = rx.recv().await {
        match job.kind {
            JobKind::ProcessImage => {
                let image_matrix = ImageMatrix::from_image(&job.image);
                let bboxes = detector.face_locations(&image_matrix);
                let landmarks = bboxes
                    .iter()
                    .map(|bbox| landmark_predictor.face_landmarks(&image_matrix, bbox))
                    .collect::<Vec<FaceLandmarks>>();
                let embeddings = face_encoder.get_face_encodings(&image_matrix, &landmarks, 0);

                let image = DynamicImage::ImageRgb8(job.image);
                let full_id = Uuid::new_v4().to_string();
                let result = bboxes
                    .iter()
                    .zip(embeddings.iter())
                    .map(|(bbox, embedding)| {
                        let id = Uuid::new_v4().to_string();
                        image
                            .crop_imm(
                                bbox.left as u32,
                                bbox.top as u32,
                                bbox.width() as u32,
                                bbox.height() as u32,
                            )
                            .save(format!("/home/alimulap/tmp/isentry/{id}.jpg"))
                            .unwrap();
                        (
                            id,
                            (
                                bbox.left,
                                bbox.top,
                                bbox.width() as u64,
                                bbox.height() as u64,
                            ),
                            embedding.to_vec(),
                        )
                    })
                    .collect::<Vec<(String, (i64, i64, u64, u64), Vec<f64>)>>();
                let mut image = image.to_rgb8();
                let font =
                    FontRef::try_from_slice(include_bytes!("../../assets/Montserrat-Medium.ttf"))
                        .unwrap();

                let font_height = 24.;
                let scale = PxScale {
                    x: font_height,
                    y: font_height,
                };
                for (_, bbox, _) in result.iter() {
                    image.label(
                        &BoundingBox {
                            top: bbox.1 as i32,
                            left: bbox.0 as i32,
                            width: bbox.2 as u32,
                            height: bbox.3 as u32,
                        },
                        "",
                        &font,
                        font_height,
                        scale,
                    );
                }
                image
                    .save(format!("/home/alimulap/tmp/isentry/{full_id}.jpg"))
                    .unwrap();
                if job
                    .tx
                    .send(JobResult::ProcessImage(full_id, result))
                    .is_err()
                {
                    tracing::error!("Requester id: {} hung up before receiving data", job.id);
                }
            }
            JobKind::AutoLabel => {
                // let start = Instant::now();
                let image_matrix = ImageMatrix::from_image(&job.image);
                // let start2 = Instant::now();
                let bboxes = detector.face_locations(&image_matrix);
                // tracing::info!("faces: {}", bboxes.len());
                let landmarks = bboxes
                    .iter()
                    .map(|bbox| landmark_predictor.face_landmarks(&image_matrix, bbox))
                    .collect::<Vec<FaceLandmarks>>();
                let bboxes = bboxes
                    .iter()
                    .map(BoundingBox::from)
                    .collect::<Vec<BoundingBox>>();
                let embeddings = face_encoder.get_face_encodings(&image_matrix, &landmarks, 0);
                // tracing::info!("NNs takes {}ms", start2.elapsed().as_millis());

                let image = DynamicImage::ImageRgb8(job.image);

                let mut cropped_images = Vec::with_capacity(bboxes.len());
                for face in bboxes.iter() {
                    cropped_images.push(
                        image
                            .crop_imm(face.left as u32, face.top as u32, face.width, face.height)
                            .into_rgb8(),
                    );
                }

                enum Label {
                    Name(String),
                    /// (id, is_new)
                    Id(u64, bool),
                }

                #[rustfmt::skip]
                let push_face = db_conn.prep("
                    INSERT INTO faces (bounding_box, embedding, updatedAt)
                    VALUES (:bounding_box, :embedding, NOW())
                ").unwrap();

                let mut faces = faces.lock().await;
                let identities = identities.lock().await;

                let names = embeddings
                    .iter()
                    .zip(bboxes.iter())
                    .map(|(embedding, bbox)| match faces.identity(embedding) {
                        (_, Some(identity_id)) => {
                            Label::Name(identities.get(&identity_id).unwrap().clone())
                        }
                        (Some(face_id), None) => Label::Id(face_id, false),
                        (None, None) => {
                            let bbox = bincode::serialize(&bbox).unwrap();
                            let embedding_bin = bincode::serialize(&embedding.to_vec()).unwrap();
                            db_conn
                                .exec_drop(
                                    &push_face,
                                    params! {
                                        "bounding_box" => bbox,
                                        "embedding" => embedding_bin
                                    },
                                )
                                .unwrap();
                            let id = db_conn.last_insert_id();
                            faces.insert(id, None, embedding.clone());
                            Label::Id(id, true)
                            // db_conn.exec(push_face, params)
                        }
                    })
                    .collect::<Vec<Label>>();

                let mut image = image.to_rgb8();

                let font =
                    FontRef::try_from_slice(include_bytes!("../../assets/Montserrat-Medium.ttf"))
                        .unwrap();

                let font_height = 24.;
                let scale = PxScale {
                    x: font_height,
                    y: font_height,
                };
                for (bbox, label) in bboxes.iter().zip(names.iter()) {
                    let name = match label {
                        Label::Name(name) => name,
                        Label::Id(id, _) => &id.to_string(),
                    };
                    image.label(bbox, name, &font, font_height, scale);
                }

                let mut tmp_dir = PathBuf::from(var("TEMP").unwrap());
                tmp_dir.push("isentry");
                // let now = Utc::now().format("%Y-%m-%d-%H:%M:%S");
                let mut full_pic_path = tmp_dir.clone();
                let uuid = Uuid::new_v4().to_string();
                full_pic_path.push(format!("auto-capture-{}.jpg", uuid));
                let full_pic_id = db_conn.last_insert_id();

                let push_pic = db_conn
                    .prep(
                        "
                        INSERT INTO medias (path, type, capture_method, updatedAt) 
                        VALUES (:path, \"PICTURE\", \"AUTO\", NOW())
                    ",
                    )
                    .unwrap();
                if !bboxes.is_empty() {
                    // let start = Instant::now();
                    db_conn
                        .exec_drop(
                            &push_pic,
                            params! {
                                "path" => full_pic_path.to_str()
                            },
                        )
                        .unwrap();
                    // let start = Instant::now();
                    if let Err(e) = image.save(&full_pic_path) {
                        tracing::warn!("Can't save image {}: {}", full_pic_path.display(), e);
                        // tracing::info!("Trying saving image in {}ms", start.elapsed().as_millis());
                    } else {
                        // tracing::info!("Saving image in {}ms", start.elapsed().as_millis());
                    }
                    // tracing::info!("Saving full pic takes {}ms", start.elapsed().as_millis());
                }

                let update_face = db_conn
                    .prep(
                        "
                        UPDATE faces 
                        SET picture_single = :single_pic, picture_full = :full_pic 
                        WHERE id = :id
                    ",
                    )
                    .unwrap();
                for name in &names {
                    if let Label::Id(id, true) = name {
                        let mut single_pic_path = tmp_dir.clone();
                        let uuid = Uuid::new_v4().to_string();
                        single_pic_path.push(format!("cropped-{}.jpg", uuid));

                        db_conn
                            .exec_drop(
                                &push_pic,
                                params! {
                                    "path" => single_pic_path.to_str()
                                },
                            )
                            .unwrap();
                        let single_pic_id = db_conn.last_insert_id();

                        db_conn
                            .exec_drop(
                                &update_face,
                                params! {
                                    "id" => id,
                                    "single_pic" => single_pic_id,
                                    "full_pic" => full_pic_id
                                },
                            )
                            .unwrap();
                        // let start = Instant::now();
                        if let Err(e) = image.save(&single_pic_path) {
                            tracing::warn!("Can't save image {}: {}", single_pic_path.display(), e);
                            // tracing::info!("Trying saving image in {}ms", start.elapsed().as_millis());
                        } else {
                            // tracing::info!("Saving image in {}ms", start.elapsed().as_millis());
                        }
                    }
                }

                let names = names
                    .into_iter()
                    .map(|name| match name {
                        Label::Name(name_str) => name_str,
                        Label::Id(id, _) => id.to_string(),
                    })
                    .collect::<Vec<String>>();

                if job
                    .tx
                    .send(JobResult::AutoLabel(
                        bboxes,
                        names,
                        // embeddings,
                        // cropped_images,
                        // image,
                    ))
                    .is_err()
                {
                    tracing::error!("Requester id: {} hung up before receiving data", job.id);
                }
                // tracing::info!("Scanning take {}ms", start.elapsed().as_millis());
            }
            JobKind::RegisterFace => {
                let image_matrix = ImageMatrix::from_image(&job.image);
                let bboxes = detector.face_locations(&image_matrix);
                if bboxes.len() != 1 {
                    if job
                        .tx
                        .send(JobResult::RegisterFace(None, bboxes.len()))
                        .is_err()
                    {
                        tracing::error!("Requester id: {} hung up before receiving data", job.id);
                    }
                    continue;
                }
                let bbox = bboxes[0];
                let landmark = landmark_predictor.face_landmarks(&image_matrix, &bbox);
                let embeddings = face_encoder.get_face_encodings(&image_matrix, &[landmark], 0);
                let embedding = &embeddings[0];

                let home = dotenvy::var("HOME").unwrap();

                let image = DynamicImage::ImageRgb8(job.image);
                let full_id = Uuid::new_v4().to_string();
                let full_path = format!("{home}/isentry/medias/{full_id}.jpg");
                let cropped_id = Uuid::new_v4().to_string();
                let cropped_path = format!("{home}/isentry/medias/{cropped_id}.jpg");
                image
                    .crop_imm(
                        bbox.left as u32,
                        bbox.top as u32,
                        bbox.width() as u32,
                        bbox.height() as u32,
                    )
                    .save(cropped_path)
                    .unwrap();

                let bbox = BoundingBox::from(&bbox);

                let bbox_bin = bincode::serialize(&bbox).unwrap();
                let embedding_bin = bincode::serialize(&embedding.to_vec()).unwrap();

                db_conn
                    .exec_drop(
                        "INSERT INTO faces (bounding_box, embedding, updatedAt)
                    VALUES (:bounding_box, :embedding, NOW())",
                        params! {
                            "bounding_box" => bbox_bin,
                            "embedding" => embedding_bin
                        },
                    )
                    .unwrap();

                let face_id = db_conn.last_insert_id();

                let mut image = image.to_rgb8();
                let font =
                    FontRef::try_from_slice(include_bytes!("../../assets/Montserrat-Medium.ttf"))
                        .unwrap();

                let font_height = 24.;
                let scale = PxScale {
                    x: font_height,
                    y: font_height,
                };

                image.label(&bbox, &face_id.to_string(), &font, font_height, scale);
                image.save(full_path.clone()).unwrap();

                db_conn
                    .exec_drop(
                        "INSERT INTO medias (path, type, capture_method, updatedAt) 
                        VALUES (:path, \"PICTURE\", \"AUTO\", NOW())",
                        params! {
                            "path" => full_path
                        },
                    )
                    .unwrap();
                let full_img_id = db_conn.last_insert_id();
                let cropped_img_id = db_conn.last_insert_id();

                db_conn
                    .exec_drop(
                        "UPDATE faces 
                        SET picture_single = :single_pic, picture_full = :full_pic 
                        WHERE id = :id",
                        params! {
                            "id" => face_id,
                            "single_pic" => cropped_img_id,
                            "full_pic" => full_img_id,
                        },
                    )
                    .unwrap();

                if job
                    .tx
                    .send(JobResult::RegisterFace(Some(face_id), bboxes.len()))
                    .is_err()
                {
                    tracing::error!("Requester id: {} hung up before receiving data", job.id);
                }
            }
        }
    }
}
