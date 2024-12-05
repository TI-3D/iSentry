use std::net::SocketAddr;

use axum::{
    routing::{any, get, post},
    Router,
};
use mysql::Pool;
use tokio::{net::TcpListener, signal, sync::mpsc::Sender};
use tracing::{error, info, warn};

use crate::job::Job;

mod error;
mod response;
mod handler;

pub use response::{IPItem, IPResponse};

pub async fn run(db_pool: mysql::Pool, tx: Sender<Job>) {
    let app = Router::new()
        .route("/", get(root))
        .route("/process-image", post(handler::process_image))
        .route("/validate-face", post(handler::validate_face))
        .route("/subscribe-notif", any(handler::subscribe_notif))
        .with_state(AppState { db_pool, tx });

    let ai_server_address = dotenvy::var("WEB_ADDRESS").unwrap();
    let ai_server_port = dotenvy::var("WEB_PORT").unwrap();

    let listener = TcpListener::bind(ai_server_address + ":" + &ai_server_port)
        .await
        .unwrap();

    axum::serve(listener, app.into_make_service_with_connect_info::<SocketAddr>())
        // .with_graceful_shutdown(shutdown_signal())
        .await
        .unwrap();
}

#[derive(Clone)]
struct AppState {
    #[allow(unused)]
    pub db_pool: Pool,
    pub tx: Sender<Job>,
}

async fn root() -> &'static str {
    info!("Hello, World!");
    warn!("Hello, World!");
    error!("Hello, World!");
    "Hello, World!"
}

async fn _shutdown_signal() {
    let ctrl_c = async {
        signal::ctrl_c()
            .await
            .expect("failed to install Ctrl+C handler");
    };

    #[cfg(unix)]
    let terminate = async {
        signal::unix::signal(signal::unix::SignalKind::terminate())
            .expect("failed to install signal handler")
            .recv()
            .await;
    };
    #[cfg(not(unix))]
    let terminate = std::future::pending::<()>();

    tokio::select! {
        _ = ctrl_c => {},
        _ = terminate => {},
    }
}
