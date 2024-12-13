use std::time::Duration;

use axum::extract::{Multipart, State};
use tokio::{
    sync::oneshot::{self, error::TryRecvError},
    time::sleep,
};
use uuid::Uuid;

use crate::{
    job::{Job, JobKind, JobResult, JobSender},
    web_server::{error::WebError, response::RFResponse, AppState},
};

pub async fn validate_face(
    State(state): State<AppState>,
    mut multipart: Multipart,
) -> Result<RFResponse, WebError> {
    let mut _filename = String::new();
    let mut image = None;
    while let Some(field) = multipart.next_field().await.unwrap() {
        if let Some(true) = field.name().map(|name| name == "image") {
            _filename = field.file_name().unwrap().to_string();
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
                kind: JobKind::RegisterFace,
                tx,
            })
            .await
            .unwrap();

        loop {
            match rx.try_recv() {
                Ok(result) => {
                    if let JobResult::RegisterFace(face_id, num_faces) = result {
                        break Ok(if let Some(face_id) = face_id {
                            tracing::info!("Channel id: {} success with face_id: {}", id, face_id);
                            RFResponse {
                                success: true,
                                face_id: Some(face_id),
                                msg: format!(
                                    "Success register face with id: {} to database",
                                    face_id
                                ),
                            }
                        } else {
                            tracing::warn!("Channel id: {} failed", id);
                            RFResponse {
                                success: false,
                                face_id: None,
                                msg: match num_faces {
                                    0 => String::from("Image does not contain a face"),
                                    1 => String::from("Something wrong with the server"),
                                    _ => String::from("Found multiple face in a single image"),
                                },
                            }
                        });
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
