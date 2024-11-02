use tokio::sync::mpsc;

mod model;
mod ffmpeg;
mod utils;
mod video_processing;
mod web_server;
mod job;

#[tokio::main]
async fn main() {
    tracing_subscriber::fmt::init();

    let (tx, _rx) = mpsc::channel(128);

    tokio::spawn(web_server::run(tx));
    tokio::spawn(video_processing::run());
}
