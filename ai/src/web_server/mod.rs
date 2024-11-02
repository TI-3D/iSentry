use axum::{routing::{get, post}, Router};
use routes::process_frame;
use tokio::{net::TcpListener, signal, sync::mpsc::Sender};
use tracing::{error, info, warn};

use crate::job::Job;

mod error;
mod response;
mod routes;

pub async fn run(tx: Sender<Job>) {
    let app = Router::new()
        .route("/", get(root))
        .route("/process-frame", post(process_frame))
        .with_state(tx);

    let listener = TcpListener::bind("localhost:3000").await.unwrap();

    axum::serve(listener, app)
        .with_graceful_shutdown(shutdown_signal())
        .await
        .unwrap();
}

async fn root() -> &'static str {
    info!("Hello, World!");
    warn!("Hello, World!");
    error!("Hello, World!");
    "Hello, World!"
}

async fn shutdown_signal() {
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
