#![allow(unused)]

use dlib_face_recognition::{FaceEncodings, FaceLandmarks, FaceLocations, Rectangle};
use image::RgbImage;
use tokio::sync::oneshot::Sender;
use uuid::Uuid;

use crate::error::AppError;

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
    /// (bbox, face_encoding, cropped_face, labelled_image)
    DetThenRec(bool, bool, bool, bool),
}

pub enum JobResult {
    Image(RgbImage),
    BBox(Rectangle),
    BBoxWI((Rectangle, RgbImage)),
    Landmark(FaceLandmarks),
    LandmarkWI((FaceLandmarks, RgbImage)),
    BBnLandM((Rectangle, FaceLandmarks)),
    BBnLandMWI((Rectangle, FaceLandmarks, RgbImage)),
    MBBnLandMWI(
        Option<FaceLocations>,
        Option<FaceEncodings>,
        Option<Vec<RgbImage>>,
        Option<RgbImage>,
    ),
    Err(AppError),
}
