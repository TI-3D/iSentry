use std::{
    sync::{
        atomic::{AtomicU8, Ordering},
        Arc,
    },
    time::Duration,
};

use ab_glyph::{FontRef, PxScale};
use chrono::Utc;
use image::RgbImage;
use mysql::{prelude::Queryable, Conn};
use opencv::{
    imgproc::COLOR_BGR2RGB, prelude::*, videoio::{VideoCapture, VideoCaptureTrait, VideoCaptureTraitConst, CAP_ANY}
};
use tokio::{
    io::AsyncWriteExt,
    sync::{mpsc::Sender, oneshot, Mutex},
    time::sleep,
};
use uuid::Uuid;

use crate::{
    ffmpeg,
    job::{DetThenRecOpts, Job, JobKind, JobResult, JobSender},
    utils::LabelID,
};

pub async fn run(_db_opts: mysql::Opts, tx: Sender<Job>) {
    // tokio::spawn(auto_record(db_opts, tx.clone()));
    tokio::spawn(auto_label(tx));
}

pub async fn auto_record(db_opts: mysql::Opts, _tx: Sender<Job>) {
    let mut db_conn = Conn::new(db_opts).unwrap();

    let stmt1 = db_conn
        .prep("INSERT INTO gallery_items (path, type, capture_method) VALUES (?1, VIDEO, AUTO)")
        .unwrap();

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

        let link = dotenvy::var("RTMP_LABEL").unwrap();
        let timestamp = Utc::now();
        let filename = format!("AutoRecord-{}.mp4", timestamp.format("%Y-%m-%d-%H:%M"));

        ffmpeg::save_chunk(&link, record_time as u64, &filename).await;
        db_conn.exec_drop(&stmt1, ("abc",)).unwrap();
    }
}

pub async fn auto_label(tx: Sender<Job>) {
    let link = dotenvy::var("RTMP_RAW").unwrap();

    let mut input = VideoCapture::from_file(&link, CAP_ANY).unwrap();
    if !input.is_opened().unwrap() {
        panic!("Can't open rtsp stream: {link}");
    }

    let target_link = dotenvy::var("RTMP_LABEL").unwrap();
    let mut output = ffmpeg::push_frames_to_rtsp(&link, &target_link)
        .await
        .unwrap();
    let mut output_stdin = output.stdin.take().unwrap();

    let mut frame_counter = 0;

    let font = FontRef::try_from_slice(include_bytes!(
        "../assets/Montserrat-Medium.ttf"
    ))
    .unwrap();

    let font_height = 24.;
    let scale = PxScale {
        x: font_height,
        y: font_height,
    };

    let bounding_boxes = Arc::new(Mutex::new(Vec::new()));
    let num_scanning_jobs = Arc::new(AtomicU8::new(0));

    loop {
        let mut buffer = Mat::default();
        input.read(&mut buffer).unwrap();
        if let Ok((false, width, height)) = buffer.size().map(|size| {
            (
                size.width == 1920 && size.height == 1080,
                size.width,
                size.height,
            )
        }) {
            panic!("Input stream is not 1920x1080; got size {width}x{height}");
        }
        frame_counter += 1;
        let mut buffer2 = Mat::default();
        opencv::imgproc::cvt_color(&buffer, &mut buffer2, COLOR_BGR2RGB, 0).unwrap();
        let Some(mut img) = RgbImage::from_raw(1920, 1080, buffer2.data_bytes().unwrap().to_vec())
        else {
            panic!("Image container not big enough");
        };

        if frame_counter % 120 == 0 && num_scanning_jobs.load(Ordering::SeqCst) <= 1 {
            num_scanning_jobs.fetch_add(1, Ordering::SeqCst);
            let tx_clone = tx.clone();
            let bounding_boxes_clone = bounding_boxes.clone();
            let img_clone = img.clone();
            let num_scanning_jobs_clone = num_scanning_jobs.clone();
            tokio::spawn(async move {
                let (ons_tx, ons_rx) = oneshot::channel::<JobResult>();

                let job_id = Uuid::new_v4();

                tx_clone
                    .send(Job {
                        id: job_id,
                        sender: JobSender::VideoProcessing,
                        image: img_clone,
                        kind: JobKind::DetThenRec(DetThenRecOpts::new(true, false, false, false)),
                        tx: ons_tx,
                    })
                    .await
                    .unwrap();

                match ons_rx.await {
                    Ok(result) => {
                        if let JobResult::MBBnLandMWI(
                            Some(bbox),
                            _embedding,
                            _cropped_imgs,
                            _labelled_img,
                        ) = result
                        {
                            *bounding_boxes_clone.lock().await = bbox;
                        }
                    }
                    Err(e) => {
                        tracing::error!("Error receiving jobresult with id {job_id}: {e}")
                    }
                }
                num_scanning_jobs_clone.fetch_sub(1, Ordering::SeqCst);
            });
        } else {
            for bbox in &*bounding_boxes.lock().await {
                img.label(bbox, "anomali", &font, font_height, scale);
            }
        }

        output_stdin.write_all(img.as_raw()).await.unwrap();
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
