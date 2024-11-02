#![allow(unused_imports)]

use std::time::Duration;

use crate::utils::Msg;
use chrono::Utc;
use tokio::{process::Command, sync::mpsc::Sender, time::sleep};
use tracing::info;

pub async fn save_chunk(link: &str, record_time: u64, filename: &str) {
    let args = [
        "-i",
        link,
        "-c",
        "copy",
        "-t",
        &record_time.to_string(),
        filename,
    ];
    info!("AutoRecord: \nrecord_time: {}", record_time);

    let mut command = Command::new("ffmpeg");
    command.args(args);
}
