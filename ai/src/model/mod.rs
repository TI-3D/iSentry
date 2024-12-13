use std::{sync::Arc, time::Duration};

use dlib_face_recognition::{FaceDetector, FaceEncoderNetwork, LandmarkPredictor};
use identity::{Faces, Identities};
use tokio::{
    sync::{mpsc::Receiver, Mutex},
    time::sleep,
};

use crate::job::{Job, JobKind};

pub mod bounding_box;
pub mod example;
mod face_detection;
mod handler;
mod identity;

pub async fn run(db_pool: mysql::Pool, mut job_rx: Receiver<Job>) {
    //let manifest_dir = dotenvy::var("CARGO_MANIFEST_DIR").unwrap();
    let detector = Arc::new(Mutex::new(FaceDetector::default()));
    //let detector = if let Ok(cnn_fd) = FaceDetectorCnn::open(format!(
    //    "{manifest_dir}/models/[face_detector] resnet-10.dat"
    //)) {
    //    Arc::new(Mutex::new(cnn_fd))
    //} else {
    //    panic!("Error loading CNN Face Detector");
    //};
    let Ok(landmark_predictor) = LandmarkPredictor::default() else {
        panic!("Error loading Landmark Predictor.");
    };
    let face_encoder = if let Ok(lp) = FaceEncoderNetwork::default() {
        Arc::new(Mutex::new(lp))
    } else {
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
            sleep(Duration::from_secs(120)).await
        }
    });

    while let Some(job) = job_rx.recv().await {
        match job.kind {
            JobKind::ProcessImage => {
                handler::process_image(
                    detector.clone(),
                    &landmark_predictor,
                    face_encoder.clone(),
                    job,
                )
                .await;
            }
            JobKind::AutoLabel => {
                handler::auto_label(
                    detector.clone(),
                    &landmark_predictor,
                    face_encoder.clone(),
                    &mut db_conn,
                    job,
                    faces.clone(),
                    identities.clone(),
                )
                .await;
            }
            JobKind::RegisterFace => {
                handler::validate_face(
                    detector.clone(),
                    &landmark_predictor,
                    face_encoder.clone(),
                    &mut db_conn,
                    job,
                )
                .await
            }
        }
    }
}
