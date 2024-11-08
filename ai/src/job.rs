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
    DetThenRec(DetThenRecOpts),
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

pub struct DetThenRecOpts {
    pub bbox: bool,
    pub embedding: bool,
    pub crop_face: bool,
    pub label_source: bool,
}

impl Default for DetThenRecOpts {
    fn default() -> Self {
        Self {
            bbox: true,
            embedding: true,
            crop_face: true,
            label_source: true,
        }
    }
}

impl DetThenRecOpts {
    pub fn new(bbox: bool, embedding: bool, crop_face: bool, label_source: bool) -> Self {
        Self {
            bbox,
            embedding,
            crop_face,
            label_source,
        }
    }
}
