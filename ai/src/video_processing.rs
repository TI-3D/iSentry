use std::{
    sync::{
        atomic::{AtomicBool, AtomicU8, Ordering},
        Arc,
    },
    time::Duration,
};

use ab_glyph::{FontRef, PxScale};
use chrono::Utc;
use image::{DynamicImage, RgbImage};
use imageproc::definitions::HasBlack;
use mysql::{params, prelude::Queryable, Conn};
use opencv::{
    imgproc::COLOR_BGR2RGB,
    prelude::*,
    videoio::{VideoCapture, VideoCaptureTrait, VideoCaptureTraitConst, CAP_ANY},
};
use tokio::{
    io::AsyncWriteExt,
    sync::{broadcast, mpsc, oneshot, Mutex},
    time::sleep,
};
use uuid::Uuid;

use crate::{
    ffmpeg,
    job::{Job, JobKind, JobResult, JobSender},
    utils::{self, DetectionOutput, LabelID},
};

static HAS_PUBLISH_LABEL: AtomicBool = AtomicBool::new(false);

pub async fn run(
    db_opts: mysql::Opts,
    job_tx: mpsc::Sender<Job>,
    detection_tx: broadcast::Sender<DetectionOutput>,
) {
    tokio::spawn(auto_record(db_opts.clone(), job_tx.clone()));
    tokio::spawn(auto_label(db_opts, job_tx, detection_tx));
}

pub async fn auto_record(db_opts: mysql::Opts, _tx: mpsc::Sender<Job>) {
    while !HAS_PUBLISH_LABEL.load(Ordering::Relaxed) {
        sleep(Duration::from_secs(1)).await;
    }
    loop {
        let mut db_conn = Conn::new(db_opts.clone()).unwrap();

        let stmt1 = db_conn
            .prep("INSERT INTO medias (path, type, capture_method, createdAt, updatedAt) VALUES (:path, \"VIDEO\", \"AUTO\", :created_at, NOW())")
            .unwrap();

        // ffmpeg -i rtsp://localhost:8554/stream -c copy -f segment -segment_time 3600 -reset_timestamps 1 output_%03d.mp4
        // ffmpeg -i rtsp://localhost:8554/stream -c copy -t 3600 output.mp4

        let time = Utc::now();
        let seconds = time.timestamp_millis() / 1000;
        let seconds_from_last_hour = seconds % 3600;
        let next_hour_in_seconds = 3600 - seconds_from_last_hour;
        let more_than_5_minutes = next_hour_in_seconds > 60 * 5;

        let record_time = if more_than_5_minutes {
            next_hour_in_seconds
        } else {
            sleep(Duration::from_secs(next_hour_in_seconds as u64)).await;
            60 * 10
        };

        let link = dotenvy::var("RTMP_LABEL").unwrap();
        let timestamp = Utc::now().format("%Y-%m-%d-%H:%M").to_string();
        let homepath = std::env::var("HOME").unwrap();
        let filepath = format!("{homepath}/AutoRecord-{timestamp}.mp4",);

        ffmpeg::save_chunk(&link, record_time as u64, &filepath).await;
        db_conn
            .exec_drop(
                &stmt1,
                params! {
                    "path" => filepath,
                    "created_at" => timestamp
                },
            )
            .unwrap();
    }
}

pub async fn auto_label(
    db_opts: mysql::Opts,
    job_tx: mpsc::Sender<Job>,
    detection_tx: broadcast::Sender<DetectionOutput>,
) {
    let link = dotenvy::var("RTMP_RAW").unwrap();

    let mut input = loop {
        let input = match VideoCapture::from_file(&link, CAP_ANY) {
            Ok(cap) => cap,
            Err(e) => {
                tracing::error!("Can't open {link}: {e}");
                continue;
            }
        };
        match input.is_opened() {
            Ok(true) => break input,
            Ok(false) => (),
            Err(e) => {
                tracing::error!("RTSP stream {link} hasn't been opened: {e}");
            }
        }
        sleep(Duration::from_secs(60)).await;
    };

    let target_link = dotenvy::var("RTMP_LABEL").unwrap();
    let mut output = ffmpeg::push_frames_to_rtsp(&link, &target_link)
        .await
        .unwrap();
    let mut output_stdin = output.stdin.take().unwrap();

    let mut frame_counter = 0;

    let font = FontRef::try_from_slice(include_bytes!("../assets/Montserrat-Medium.ttf")).unwrap();

    let font_height = 24.;
    let scale = PxScale {
        x: font_height,
        y: font_height,
    };

    let bounding_boxes = Arc::new(Mutex::new(Vec::new()));
    let num_scanning_jobs = Arc::new(AtomicU8::new(0));

    HAS_PUBLISH_LABEL.store(true, Ordering::Relaxed);

    const IMAGE_WIDTH: i32 = 960;
    const IMAGE_HEIGHT: i32 = 540;

    loop {
        let mut buffer = Mat::default();
        input.read(&mut buffer).unwrap();
        let (width, height) = match buffer.size().map(|size| {
            (
                // size.width == 1920 && size.height == 1080,
                size.width,
                size.height,
            )
        }) {
            // (false, w, h) => panic!("Input stream is not 1920x1080; got size {w}x{h}"),
            Ok((0, 0)) => {
                sleep(Duration::from_millis(100)).await;
                continue;
            }
            Ok(size) => size,
            Err(e) => {
                tracing::error!("Error getting buffer size: {e}");
                panic!("what");
            }
        };
        frame_counter += 1;
        let mut buffer2 = Mat::default();
        opencv::imgproc::cvt_color(&buffer, &mut buffer2, COLOR_BGR2RGB, 0).unwrap();
        let mut img = RgbImage::from_raw(
            width as u32,
            height as u32,
            buffer2.data_bytes().unwrap().to_vec(),
        )
        .unwrap();
        if (width != IMAGE_WIDTH) && (height != IMAGE_HEIGHT) {
            let img_dyn = DynamicImage::ImageRgb8(img);
            img = utils::resize_and_pad_image(
                &img_dyn,
                IMAGE_WIDTH as u32,
                IMAGE_HEIGHT as u32,
                image::Rgb::black(),
            );
        }

        if frame_counter % 120 == 0 && num_scanning_jobs.load(Ordering::SeqCst) <= 1 {
            //tracing::info!("Something");
            num_scanning_jobs.fetch_add(1, Ordering::SeqCst);
            let tx_clone = job_tx.clone();
            let db_opts = db_opts.clone();
            let bounding_boxes_clone = bounding_boxes.clone();
            let bounding_boxes_clone2 = bounding_boxes.clone();
            let img_clone = img.clone();
            let num_scanning_jobs_clone = num_scanning_jobs.clone();
            let handler = tokio::spawn(async move {
                let (ons_tx, ons_rx) = oneshot::channel::<JobResult>();

                let job_id = Uuid::new_v4();

                tx_clone
                    .send(Job {
                        id: job_id,
                        sender: JobSender::VideoProcessing,
                        image: img_clone,
                        kind: JobKind::AutoLabel,
                        tx: ons_tx,
                    })
                    .await
                    .unwrap();

                match ons_rx.await {
                    Ok(result) => {
                        if let JobResult::AutoLabel(bbox, names) = result {
                            *bounding_boxes_clone.lock().await =
                                bbox.into_iter().zip(names.into_iter()).collect::<Vec<_>>();
                        }
                    }
                    Err(e) => {
                        tracing::error!("Error receiving jobresult with id {job_id}: {e}")
                    }
                }
                num_scanning_jobs_clone.fetch_sub(1, Ordering::SeqCst);
            });
            let detection_tx = detection_tx.clone();
            tokio::spawn(async move {
                let _ = handler.await;
                // let mut ids = Vec::new();
                // for (_, (id, _)) in &*bounding_boxes_clone2.lock().await {
                //     ids.push(*id);
                // }
                // let response: Value = reqwest::Client::new()
                //     .post("http://localhost:3000/api/detection-logs/create-many")
                //     .json(&ids)
                //     .send()
                //     .await
                //     .unwrap()
                //     .json()
                //     .await
                //     .unwrap();
                // println!("{response}");
                let mut db_conn = Conn::new(db_opts).unwrap();
                let push_log = db_conn
                    .prep("INSERT INTO detectionLogs (face) VALUES (:face_id)")
                    .unwrap();
                for (_, (id, name)) in &*bounding_boxes_clone2.lock().await {
                    db_conn
                        .exec_drop(
                            push_log.clone(),
                            params! {
                                "face_id" => id
                            },
                        )
                        .unwrap();
                    let detection_id = db_conn.last_insert_id();
                    if let Err(e) = detection_tx.send((name.clone(), *id, detection_id)) {
                        tracing::error!("An error occured during detection report sending: {e}");
                    }
                }
            });
        } else {
            for (bbox, (_, name)) in &*bounding_boxes.lock().await {
                img.label(bbox, name, &font, font_height, scale);
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
