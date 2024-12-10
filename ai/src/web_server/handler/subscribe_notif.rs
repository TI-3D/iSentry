use std::net::SocketAddr;

use axum::{
    extract::{
        ws::{Message, WebSocket},
        ConnectInfo, State, WebSocketUpgrade,
    },
    response::IntoResponse,
};
use axum_extra::{headers::UserAgent, TypedHeader};
use serde_json::json;
use tokio::sync::broadcast;

use crate::{utils::DetectionOutput, web_server::AppState};

pub async fn subscribe_notif(
    ws: WebSocketUpgrade,
    user_agent: Option<TypedHeader<UserAgent>>,
    ConnectInfo(addr): ConnectInfo<SocketAddr>,
    State(app_state): State<AppState>,
) -> impl IntoResponse {
    let user_agent = if let Some(TypedHeader(user_agent)) = user_agent {
        user_agent.to_string()
    } else {
        String::from("Unknown browser")
    };
    println!("`{user_agent}` at {addr} connected.");

    let detection_rx = app_state.detection_rx.lock().await.resubscribe();

    ws.on_upgrade(move |socket| handle_subscriber(socket, addr, detection_rx))
}

async fn handle_subscriber(
    mut socket: WebSocket,
    who: SocketAddr,
    mut detection_rx: broadcast::Receiver<DetectionOutput>,
) {
    if socket.send(Message::Ping(vec![1, 2, 3])).await.is_ok() {
        println!("Pinged {who}...");
    } else {
        println!("Could not send ping {who}!");
        return;
    }

    loop {
        match detection_rx.recv().await {
            Ok(detection) => socket
                .send(Message::Text(
                    serde_json::to_string(&json!({
                        "name": detection.0,
                        "face_id": detection.1,
                        "detection_id": detection.2
                    }))
                    .unwrap(),
                ))
                .await
                .unwrap(),
            Err(broadcast::error::RecvError::Lagged(skipped_count)) => tracing::warn!(
                "Channel with client {who} lagged with {skipped_count} skipped message"
            ),
            Err(broadcast::error::RecvError::Closed) => {
                tracing::warn!("Client {who} abruptly disconnected");
                break;
            }
        }
    }
}
