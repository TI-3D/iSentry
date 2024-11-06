use axum::extract::{Multipart, State};
use tokio::sync::{
    mpsc::Sender,
    oneshot::{self, error::TryRecvError},
};
use tracing::{error, info};
use uuid::Uuid;

use crate::job::{Job, JobKind, JobResult, JobSender};

use super::{error::WebError, response::Image, AppState};

pub async fn process_frame(
    State(state): State<AppState>,
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
        let (tx, mut rx) = oneshot::channel::<JobResult>();

        // let image = image.resize_exact(112, 112, FilterType::CatmullRom);
        let image = image.into_rgb8();

        let id = Uuid::new_v4();

        state.tx
            .send(Job {
                id,
                sender: JobSender::WebServer,
                image,
                kind: JobKind::DetThenRec((true, true, true, true)),
                tx,
            })
            .await
            .unwrap();

        loop {
            match rx.try_recv() {
                Ok(result) => {
                    if let JobResult::Image(image) = result {
                        info!("Channel id: {} success with filename: {}", id, filename);
                        break Ok(Image {
                            filename,
                            data: image,
                        });
                    } else {
                        error!("Channel id: {} got unexpected result from model", id);
                    }
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
