use axum::extract::{Multipart, State};
use image::RgbImage;
use tokio::sync::{
    mpsc::Sender,
    oneshot::{self, error::TryRecvError},
};
use tracing::{error, info};
use uuid::Uuid;

use crate::job::{Job, JobSender};

use super::{error::WebError, response::Image};

pub async fn process_frame(
    State(sender): State<Sender<Job>>,
    mut multipart: Multipart,
) -> Result<Image, WebError> {
    let mut filename = String::new();
    let mut image = None;
    while let Some(field) = multipart.next_field().await.unwrap() {
        if let Some(true) = field.name().map(|name| name == "image") {
            filename = field.file_name().unwrap().to_string();
            image = Some(image::load_from_memory(&field.bytes().await.unwrap()).unwrap());
        }
    }
    if let Some(image) = image {
        let (tx, mut rx) = oneshot::channel::<RgbImage>();

        // let image = image.resize_exact(112, 112, FilterType::CatmullRom);
        let image = image.into_rgb8();

        let id = Uuid::new_v4();

        sender
            .send(Job {
                id,
                sender: JobSender::WebServer,
                image,
                tx,
            })
            .await
            .unwrap();

        loop {
            match rx.try_recv() {
                Ok(image) => {
                    info!("Channel id: {} success with filename: {}", id, filename);
                    break Ok(Image {
                        filename,
                        data: image,
                    })
                }
                Err(TryRecvError::Empty) => (),
                Err(TryRecvError::Closed) => {
                    error!("Channel id: {} closed unexpectedly", id);
                    break Err(WebError::ChannelClosed);
                }
            }
        }
    } else {
        Err(WebError::NoImageFound)
    }
}
