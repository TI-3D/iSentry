use std::sync::Arc;

use ab_glyph::{FontRef, PxScale};
use dlib_face_recognition::{
    FaceDetector, FaceDetectorCnn, FaceDetectorTrait, FaceEncoderNetwork, FaceEncoderTrait, ImageMatrix, LandmarkPredictor, LandmarkPredictorTrait
};
use image::DynamicImage;
use mysql::{params, prelude::Queryable, PooledConn};
use tokio::sync::Mutex;
use uuid::Uuid;

use crate::{
    job::{Job, JobResult},
    model::bounding_box::BoundingBox,
    utils::LabelID,
};

pub async fn validate_face(
    //detector: Arc<Mutex<FaceDetector>>,
    detector: Arc<Mutex<FaceDetectorCnn>>,
    landmark_predictor: &LandmarkPredictor,
    face_encoder: Arc<Mutex<FaceEncoderNetwork>>,
    db_conn: &mut PooledConn,
    job: Job,
    // faces: Arc<Mutex<Faces>>,
    // identities: Arc<Mutex<Identities>>,
) {
    let image_matrix = ImageMatrix::from_image(&job.image);
    let detector = detector.lock().await;
    let bboxes = detector.face_locations(&image_matrix);
    if bboxes.len() != 1 {
        if job
            .tx
            .send(JobResult::RegisterFace(None, bboxes.len()))
            .is_err()
        {
            tracing::error!("Requester id: {} hung up before receiving data", job.id);
        }
        return;
    }
    let bbox = bboxes[0];
    let landmark = landmark_predictor.face_landmarks(&image_matrix, &bbox);
    let face_encoder = face_encoder.lock().await;
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
        FontRef::try_from_slice(include_bytes!("../../../assets/Montserrat-Medium.ttf")).unwrap();

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
