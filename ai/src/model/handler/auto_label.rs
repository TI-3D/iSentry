use std::{path::PathBuf, sync::Arc};

use ab_glyph::{FontRef, PxScale};
use dlib_face_recognition::{
    FaceDetector, FaceDetectorTrait, FaceEncoderNetwork, FaceEncoderTrait, FaceLandmarks,
    ImageMatrix, LandmarkPredictor, LandmarkPredictorTrait,
};
use image::DynamicImage;
use mysql::{params, prelude::Queryable, PooledConn};
use tokio::sync::Mutex;
use uuid::Uuid;

use crate::{
    job::{Job, JobResult},
    model::{
        bounding_box::BoundingBox,
        identity::{Faces, Identities},
    },
    utils::LabelID,
};

pub async fn auto_label(
    detector: Arc<Mutex<FaceDetector>>,
    //detector: Arc<Mutex<FaceDetectorCnn>>,
    landmark_predictor: &LandmarkPredictor,
    face_encoder: Arc<Mutex<FaceEncoderNetwork>>,
    db_conn: &mut PooledConn,
    job: Job,
    faces: Arc<Mutex<Faces>>,
    identities: Arc<Mutex<Identities>>,
) {
    // let start = Instant::now();
    let image_matrix = ImageMatrix::from_image(&job.image);
    // let start2 = Instant::now();
    let detector = detector.lock().await;
    let bboxes = detector.face_locations(&image_matrix);
    tracing::info!("faces: {}", bboxes.len());
    if bboxes.is_empty() {
        if job.tx.send(JobResult::AutoLabel(vec![], vec![])).is_err() {
            tracing::error!("Requester id: {} hung up before receiving data", job.id);
        }
    } else {
        let landmarks = bboxes
            .iter()
            .map(|bbox| landmark_predictor.face_landmarks(&image_matrix, bbox))
            .collect::<Vec<FaceLandmarks>>();
        let bboxes = bboxes
            .iter()
            .map(BoundingBox::from)
            .collect::<Vec<BoundingBox>>();
        let face_encoder = face_encoder.lock().await;
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
            Name(u64, String),
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
                (Some(face_id), Some(identity_id)) => {
                    Label::Name(face_id, identities.get(&identity_id).unwrap().clone())
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
                _ => panic!("HOW?"),
            })
            .collect::<Vec<Label>>();

        let mut image = image.to_rgb8();

        let font = FontRef::try_from_slice(include_bytes!("../../../assets/Montserrat-Medium.ttf"))
            .unwrap();

        let font_height = 24.;
        let scale = PxScale {
            x: font_height,
            y: font_height,
        };
        for (bbox, label) in bboxes.iter().zip(names.iter()) {
            let name = match label {
                Label::Name(_, name) => name,
                Label::Id(id, _) => &id.to_string(),
            };
            image.label(bbox, name, &font, font_height, scale);
        }

        let media_dir = PathBuf::from(dotenvy::var("ISENTRY_MEDIA_DIR").unwrap());
        // let now = Utc::now().format("%Y-%m-%d-%H:%M:%S");
        let mut full_pic_path = media_dir.clone();
        let uuid = Uuid::new_v4().to_string();
        full_pic_path.push(format!("auto-capture-{}.jpg", uuid));

        let push_pic = db_conn
            .prep(
                "
                    INSERT INTO medias (path, type, capture_method, updatedAt) 
                    VALUES (:path, \"PICTURE\", \"AUTO\", NOW())
                    ",
            )
            .unwrap();
        if let Err(e) = image.save(&full_pic_path) {
            tracing::warn!("Can't save image {}: {}", full_pic_path.display(), e);
        }
        db_conn
            .exec_drop(
                &push_pic,
                params! {
                    "path" => full_pic_path.to_str()
                },
            )
            .unwrap();
        let full_pic_id = db_conn.last_insert_id();

        let update_face = db_conn
            .prep(
                "
                UPDATE faces 
                SET picture_single = :single_pic, picture_full = :full_pic 
                WHERE id = :id
                ",
            )
            .unwrap();

        for (name, cropped) in names.iter().zip(cropped_images.iter()) {
            if let Label::Id(id, true) = name {
                let mut single_pic_path = media_dir.clone();
                let uuid = Uuid::new_v4().to_string();
                single_pic_path.push(format!("cropped-{}.jpg", uuid));

                if let Err(e) = cropped.save(&single_pic_path) {
                    tracing::warn!("Can't save image {}: {}", single_pic_path.display(), e);
                    continue;
                }

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
            }
        }

        let names = names
            .into_iter()
            .map(|name| match name {
                Label::Name(id, name_str) => (id, name_str),
                Label::Id(id, _) => (id, format!("anomali#{id}")),
            })
            .collect::<Vec<(u64, String)>>();

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
}
