use std::sync::Arc;

use ab_glyph::{FontRef, PxScale};
use dlib_face_recognition::{
    FaceDetector, FaceDetectorCnn, FaceDetectorTrait, FaceEncoderNetwork, FaceEncoderTrait, FaceLandmarks, ImageMatrix, LandmarkPredictor, LandmarkPredictorTrait
};
use image::DynamicImage;
use tokio::sync::Mutex;
use uuid::Uuid;

use crate::{
    job::{Job, JobResult},
    model::bounding_box::BoundingBox,
    utils::LabelID,
};

pub async fn process_image(
    //detector: Arc<Mutex<FaceDetector>>,
    detector: Arc<Mutex<FaceDetectorCnn>>,
    landmark_predictor: &LandmarkPredictor,
    face_encoder: Arc<Mutex<FaceEncoderNetwork>>,
    job: Job,
) {
    let image_matrix = ImageMatrix::from_image(&job.image);
    let detector = detector.lock().await;
    let bboxes = detector.face_locations(&image_matrix);
    let landmarks = bboxes
        .iter()
        .map(|bbox| landmark_predictor.face_landmarks(&image_matrix, bbox))
        .collect::<Vec<FaceLandmarks>>();
    let face_encoder = face_encoder.lock().await;
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
        FontRef::try_from_slice(include_bytes!("../../../assets/Montserrat-Medium.ttf")).unwrap();

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
