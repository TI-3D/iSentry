use image::RgbImage;
use tokio::sync::oneshot::Sender;
use uuid::Uuid;

pub struct Job {
    pub id: Uuid,
    pub sender: JobSender,
    pub image: RgbImage,
    pub tx: Sender<RgbImage>
}

pub enum JobSender {
    WebServer,
    VideoProcessing
}
