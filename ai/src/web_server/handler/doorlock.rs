use std::{net::SocketAddr, time::Duration};

use axum::{
    extract::{
        ws::{Message, WebSocket},
        ConnectInfo, State, WebSocketUpgrade,
    },
    response::IntoResponse,
};
use axum_extra::{headers::UserAgent, TypedHeader};
use tokio::{sync::broadcast, time::sleep};

use crate::web_server::AppState;

pub async fn doorlock(
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

    let doorlock_rx = app_state.doorlock_rx.lock().await.resubscribe();

    ws.on_upgrade(move |socket| handle_subscriber(socket, addr, doorlock_rx))
}

async fn handle_subscriber(
    mut socket: WebSocket,
    who: SocketAddr,
    mut doorlock_rx: broadcast::Receiver<()>,
) {
    if socket.send(Message::Ping(vec![1, 2, 3])).await.is_ok() {
        println!("Pinged {who}...");
    } else {
        println!("Could not send ping {who}!");
        return;
    }

    loop {
        match doorlock_rx.recv().await {
            Ok(()) => socket.send(Message::Text("unlock".into())).await.unwrap(),
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


pub async fn doorlock_test(
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

    let doorlock_rx = app_state.doorlock_rx.lock().await.resubscribe();

    ws.on_upgrade(move |socket| handle_subscriber_test(socket, addr, doorlock_rx))
}

async fn handle_subscriber_test(
    mut socket: WebSocket,
    who: SocketAddr,
    mut _doorlock_rx: broadcast::Receiver<()>,
) {
    if socket.send(Message::Ping(vec![1, 2, 3])).await.is_ok() {
        println!("Pinged {who}...");
    } else {
        println!("Could not send ping {who}!");
        return;
    }

    loop {
        socket.send(Message::Text("Kocag".into())).await.unwrap();
        sleep(Duration::from_secs(1)).await;
    }
}
