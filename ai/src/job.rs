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
    Detection,
    Recognition,
    AutoLabel,
}

pub enum JobResult {
    Image(RgbImage),
    AutoLabel(
        Vec<BoundingBox>,
        Vec<String>,
        //FaceEncodings,
        //Vec<RgbImage>,
        //RgbImage,
    ),
    Err(AppError),
}

