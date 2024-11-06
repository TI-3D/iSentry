use std::{task::Wake, time::Duration};

use chrono::Utc;
use mysql::{prelude::Queryable, Conn};
use tokio::{sync::mpsc::Sender, time::sleep};

use crate::{ffmpeg, job::Job};

pub async fn run(db_opts: mysql::Opts, tx: Sender<Job>) {
    tokio::spawn(auto_record(db_opts, tx));
}

// pub async fn auto_record(tx: Sender<Msg>) {
pub async fn auto_record(db_opts: mysql::Opts, tx: Sender<Job>) {
    let mut db_conn = Conn::new(db_opts).unwrap();

    let stmt1 = db_conn.prep("INSERT INTO gallery_items (path, type, capture_method) VALUES (?1, VIDEO, AUTO)").unwrap();

    loop {
        // ffmpeg -i rtsp://localhost:8554/stream -c copy -f segment -segment_time 3600 -reset_timestamps 1 output_%03d.mp4
        // ffmpeg -i rtsp://localhost:8554/stream -c copy -t 3600 output.mp4
        
        let time = Utc::now();
        let seconds = time.timestamp_millis() / 1000;
        let seconds_from_last_hour = seconds % 3600;
        let next_hour_in_seconds = 3600 - seconds_from_last_hour;
        let more_than_5_minutes = next_hour_in_seconds > 60;

        let record_time = if more_than_5_minutes {
            next_hour_in_seconds
        } else {
            sleep(Duration::from_secs(next_hour_in_seconds as u64)).await;
            3600
        };

        let link = dotenvy::var("RTSP_CAMERA").unwrap();
        let timestamp = Utc::now();
        let filename = format!("AutoRecord-{}.mp4", timestamp.format("%Y-%m-%d-%H:%M"));

        ffmpeg::save_chunk(
            &link,
            record_time as u64,
            &filename,
        )
        .await;
        db_conn.exec_drop(&stmt1, ("abc",)).unwrap();
    }
}

#[test]
fn chrono_format() {
    let time = Utc::now();
    let milis = time.timestamp_millis();
    let milis_from_last_hour = milis % 3600000;
    let more_than_a_minute = milis_from_last_hour > 60000;
    println!("{}", time.format("%Y-%m-%d-%H:%M"));
    println!("{}", milis_from_last_hour);
    println!("{}", more_than_a_minute);
}

// #[tokio::test]
// async fn record_chunk_test() {
//     tracing_subscriber::fmt::init();
//     auto_record().await
// }
