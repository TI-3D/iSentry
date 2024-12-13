#![allow(unused)]

use dlib_face_recognition::{FaceEncodings, FaceLandmarks, FaceLocations, Rectangle};
use image::RgbImage;
use tokio::sync::oneshot::Sender;
use uuid::Uuid;

use crate::{error::AppError, model::bounding_box::BoundingBox};

pub struct Job {
    pub id: Uuid,
    pub sender: JobSender,
    pub image: RgbImage,
    pub kind: JobKind,
    pub tx: Sender<JobResult>,
}

pub enum JobSender {
    WebServer,
    VideoProcessing,
}

pub enum JobKind {
    AutoLabel,
    ProcessImage,
    RegisterFace,
}

pub enum JobResult {
    AutoLabel(Vec<BoundingBox>, Vec<(u64, String)>),
    #[allow(clippy::type_complexity)]
    ProcessImage(String, Vec<(String, (i64, i64, u64, u64), Vec<f64>)>),
    RegisterFace(Option<u64>, usize),
    Err(AppError),
}
