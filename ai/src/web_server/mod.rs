use std::{net::SocketAddr, sync::Arc};

use axum::{
    routing::{any, get, post},
    Router,
};
use mysql::Pool;
use tokio::{
    net::TcpListener,
    signal,
    sync::{broadcast, mpsc, Mutex},
};
use tracing::{error, info, warn};

use crate::{job::Job, utils::DetectionOutput};

mod error;
mod handler;
mod response;

pub use response::{IPItem, IPResponse};

pub async fn run(
    db_pool: mysql::Pool,
    job_tx: mpsc::Sender<Job>,
    detection_rx: broadcast::Receiver<DetectionOutput>,
    doorlock_rx: broadcast::Receiver<()>,
) {
    let detection_rx = Arc::new(Mutex::new(detection_rx));
    let doorlock_rx = Arc::new(Mutex::new(doorlock_rx));
    let app = Router::new()
        .route("/", get(root))
        .route("/process-image", post(handler::process_image))
        .route("/validate-face", post(handler::validate_face))
        .route("/subscribe-notif", any(handler::subscribe_notif))
        .route("doorlock", any(handler::doorlock))
        .with_state(AppState {
            db_pool,
            job_tx,
            detection_rx,
            doorlock_rx,
        });

    let ai_server_address = dotenvy::var("WEB_ADDRESS").unwrap();
    let ai_server_port = dotenvy::var("WEB_PORT").unwrap();

    let listener = TcpListener::bind(ai_server_address + ":" + &ai_server_port)
        .await
        .unwrap();

    axum::serve(
        listener,
        app.into_make_service_with_connect_info::<SocketAddr>(),
    )
    // .with_graceful_shutdown(shutdown_signal())
    .await
    .unwrap();
}

#[derive(Clone)]
struct AppState {
    #[allow(unused)]
    pub db_pool: Pool,
    pub job_tx: mpsc::Sender<Job>,
    pub detection_rx: Arc<Mutex<broadcast::Receiver<DetectionOutput>>>,
    pub doorlock_rx: Arc<Mutex<broadcast::Receiver<()>>>,
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
