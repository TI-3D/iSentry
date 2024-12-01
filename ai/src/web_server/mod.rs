use axum::{
    routing::{get, post},
    Router,
};
use handlers::{process_image, register_face};
use mysql::Pool;
use tokio::{net::TcpListener, signal, sync::mpsc::Sender};
use tracing::{error, info, warn};

use crate::job::Job;

mod error;
mod handlers;
mod response;

pub use response::{IPItem, IPResponse};

pub async fn run(db_pool: mysql::Pool, tx: Sender<Job>) {
    let app = Router::new()
        .route("/", get(root))
        .route("/process-image", post(process_image))
        .route("/register-face", post(register_face))
        .with_state(AppState { db_pool, tx });

    let ai_server_address = dotenvy::var("WEB_ADDRESS").unwrap();
    let ai_server_port = dotenvy::var("WEB_PORT").unwrap();

    let listener = TcpListener::bind(ai_server_address + ":" + &ai_server_port)
        .await
        .unwrap();

    axum::serve(listener, app)
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
