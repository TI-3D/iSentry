use std::time::Duration;

use axum::extract::{Multipart, State};
use tokio::{
    sync::oneshot::{self, error::TryRecvError},
    time::sleep,
};
use uuid::Uuid;

use crate::{
    job::{Job, JobKind, JobResult, JobSender},
    web_server::{error::WebError, AppState, IPItem, IPResponse},
};

pub async fn process_image(
    State(state): State<AppState>,
    mut multipart: Multipart,
) -> Result<IPResponse, WebError> {
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

        state
            .job_tx
            .send(Job {
                id,
                sender: JobSender::WebServer,
                image,
                kind: JobKind::ProcessImage,
                tx,
            })
            .await
            .unwrap();

        loop {
            match rx.try_recv() {
                Ok(result) => {
                    if let JobResult::ProcessImage(full_id, result) = result {
                        let result = IPResponse {
                            full_id,
                            cropped_imgs: result
                                .into_iter()
                                .map(|item| IPItem {
                                    id: item.0,
                                    bounding_box: item.1,
                                    embedding: item.2,
                                })
                                .collect::<Vec<IPItem>>(),
                        };
                        tracing::info!("Channel id: {} success with filename: {}", id, filename);
                        break Ok(result);
                    } else {
                        tracing::error!("Channel id: {} got unexpected result from model", id);
                        break Err(WebError::UnexpectedResult);
                    }
                }
                Err(TryRecvError::Empty) => {
                    tracing::info!("channel empty");
                    sleep(Duration::from_secs(1)).await;
                }
                Err(TryRecvError::Closed) => {
                    tracing::error!("Channel id: {} closed unexpectedly", id);
                    break Err(WebError::ChannelClosed);
                }
            }
        }
    } else {
        Err(WebError::NoImageFound)
    }
}
