#![allow(dead_code)]

use std::{env::var, path::PathBuf};

use ab_glyph::{FontRef, PxScale};
use bounding_box::BoundingBox;
use chrono::Utc;
// use ab_glyph::{FontRef, Scale};
use dlib_face_recognition::{
    FaceDetector, FaceDetectorTrait, FaceEncoderNetwork, FaceEncoderTrait, FaceLandmarks,
    ImageMatrix, LandmarkPredictor, LandmarkPredictorTrait,
};
use identity::{Faces, Identities};
use image::DynamicImage;
use mysql::{params, prelude::Queryable};
use tokio::sync::mpsc::Receiver;
use tracing::info;
use utils::LabelID;

use crate::job::{Job, JobKind, JobResult};

pub mod bounding_box;
mod face_detection;
mod identity;
mod utils;
mod example;

pub async fn run(db_pool: mysql::Pool, mut rx: Receiver<Job>) {
    let detector = FaceDetector::default();
    let Ok(landmark_predictor) = LandmarkPredictor::default() else {
        panic!("Error loading Landmark Predictor.");
    };
    let Ok(face_encoder) = FaceEncoderNetwork::default() else {
        panic!("Error loading Face Encoder.");
    };

    let mut db_conn = db_pool.get_conn().unwrap();

    let faces = Faces::default();
    let identities = Identities::default();

    while let Some(job) = rx.recv().await {
        match job.kind {
            JobKind::Detection => (),
            JobKind::Recognition => (),
            JobKind::DetThenRec(opts) => {
                let image_matrix = ImageMatrix::from_image(&job.image);
                let bboxes = detector.face_locations(&image_matrix);
                let landmarks = bboxes
                    .iter()
                    .map(|face| landmark_predictor.face_landmarks(&image_matrix, face))
                    .collect::<Vec<FaceLandmarks>>();
                let bboxes = bboxes
                    .iter()
                    .map(BoundingBox::from)
                    .collect::<Vec<BoundingBox>>();
                let embeddings = face_encoder.get_face_encodings(&image_matrix, &landmarks, 0);

                let image = DynamicImage::ImageRgb8(job.image);

                let mut cropped_images =
                    Vec::with_capacity(if opts.crop_face { bboxes.len() } else { 0 });
                if opts.crop_face {
                    for face in bboxes.iter() {
                        cropped_images.push(
                            image
                                .crop_imm(
                                    face.left as u32,
                                    face.top as u32,
                                    face.width,
                                    face.height,
                                )
                                .into_rgb8(),
                        );
                    }
                }

                enum Label {
                    Name(String),
                    /// (id, is_new)
                    Id(u64, bool),
                }

                let push_face = db_conn.prep("INSERT INTO faces (bounding_box, embedding) VALUES (:bounding_box, :embedding)").unwrap();

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
                            let embedding = bincode::serialize(&embedding.to_vec()).unwrap();
                            db_conn
                                .exec_drop(
                                    &push_face,
                                    params! {
                                        "bounding_box" => bbox,
                                        "embedding" => embedding
                                    },
                                )
                                .unwrap();
                            let id = db_conn.last_insert_id();
                            Label::Id(id, true)
                            // db_conn.exec(push_face, params)
                        }
                    })
                    .collect::<Vec<Label>>();

                let mut image = image.to_rgb8();

                let font = FontRef::try_from_slice(include_bytes!(
                    "C:/Users/alimulap/Downloads/Montserrat/static/Montserrat-Medium.ttf"
                ))
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

                let tmp_dir = PathBuf::from(var("TEMP").unwrap());
                let now = Utc::now().format("%Y-%m-%d-%H:%M");
                let mut full_pic_path = tmp_dir.clone();
                full_pic_path.push(format!("auto-capture-{}", now));
                let full_pic_id = db_conn.last_insert_id();

                let push_pic = db_conn
                    .prep(
                        "
                        INSERT INTO gallery_items (path, type, capture_method) 
                        VALUES (:path, \"PICTURE\", \"AUTO\")
                    ",
                    )
                    .unwrap();
                db_conn
                    .exec_drop(
                        &push_pic,
                        params! {
                            "path" => full_pic_path.to_str()
                        },
                    )
                    .unwrap();

                let update_face = db_conn
                    .prep(
                        "
                        UPDATE faces 
                        SET picture_single = :single_pic, picture_full = :full_pic 
                        WHERE id = :id
                    ",
                    )
                    .unwrap();
                for name in names {
                    if let Label::Id(id, true) = name {
                        let mut single_pic_path = tmp_dir.clone();
                        single_pic_path.push(format!("cropped-{}", now));

                        db_conn.exec_drop(&push_pic, params! {
                            "path" => single_pic_path.to_str()
                        }).unwrap();
                        let single_pic_id = db_conn.last_insert_id();

                        db_conn.exec_drop(
                            &update_face,
                            params! {
                                "id" => id,
                                "single_pic" => single_pic_id,
                                "full_pic" => full_pic_id
                            },
                        ).unwrap();
                    }
                }

                if job
                    .tx
                    .send(JobResult::MBBnLandMWI(
                        opts.bbox.then_some(bboxes),
                        opts.embedding.then_some(embeddings),
                        opts.crop_face.then_some(cropped_images),
                        opts.label_source.then_some(image),
                    ))
                    .is_err()
                {
                    info!("Requester id: {} hung up before receiving data", job.id);
                }
            }
        }
    }
}
