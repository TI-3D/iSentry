use std::{process::Stdio, time::Duration};

use tokio::{
    io,
    process::{Child, Command},
    time::sleep,
};
use tracing::info;

pub async fn save_chunk(link: &str, record_time: u64, filename: &str) {
    let max_retires = 20;
    let mut attempt = 0;
    while attempt < max_retires {
        attempt += 1;

        #[rustfmt::skip]
        let args = [
            //"-rw_timeout", "5000000",
            "-hide_banner",
            "-loglevel", "warning",
            "-i", link,
            "-c", "copy",
            "-t", &record_time.to_string(),
            filename,
        ];
        info!("AutoRecord: \npath: {filename} \nrecord_time: {}", record_time);

        let mut command = Command::new("ffmpeg");
        command.args(args);
        let mut process = match command.spawn() {
            Ok(proc) => proc,
            Err(e) => {
                tracing::error!("Failed to start ffmpeg: {e}");
                continue; // Retry on failure to spawn
            }
        };

        let exit_status = match process.wait().await {
            Ok(status) if status.success() => {
                tracing::info!("SaveChunk succeeded with exit_status: {status}");
                break; // Exit loop if ffmpeg succeeded
            }
            Ok(status) => {
                tracing::warn!("ffmpeg failed with exit_status: {status}");
                status
            }
            Err(e) => {
                tracing::error!("Error waiting for ffmpeg: {e}");
                continue;
            }
        };
        tracing::info!("SaveChunk exit_status: {exit_status}");

        tracing::info!("Retrying in 5 seconds...");
        sleep(Duration::from_secs(5)).await; // Wait before retrying
    }
}

pub async fn generate_thumbails(link: &str) -> io::Result<Child> {
    Command::new("ffmpeg")
        .args([
            // "-hide_banner", "-loglevel", "error",
            // "-i", "rtsp://localhost:8554/stream",  // Input RTSP stream
            "-i", link, // Input RTSP stream
            "-vf", "fps=30", // Set frame rate
            "-f", "rawvideo", // Output raw video data
            "-pix_fmt", "rgb24", // Use RGB24 pixel format (3 bytes per pixel)
            "-",     // Output to stdout
        ])
        .stdout(Stdio::piped()) // Capture stdout
        .spawn()
}

#[rustfmt::skip]
pub async fn push_frames_to_rtsp(_audio_link: &str, target_link: &str) -> io::Result<Child> {
    Command::new("ffmpeg")
        .args([
            "-hide_banner", "-loglevel", "warning",
            "-framerate", "30",                   // Set frame rate
            "-f", "rawvideo",                     // Raw video format
            "-pix_fmt", "rgb24",                  // Pixel format (RGB)
            "-s", &format!("{}x{}", 960, 540),// Frame size
            "-i", "-",                            // Input from stdin
            // "-itsoffset", "0.5",                  // Sync audio with the video
            // "-i", audio_link, // Input RTSP audio stream
            // "-c:v", "libx264",                    // Encode video as H.264
            "-pix_fmt", "yuv420p",                // Use YUV pixel format for video
            // "-c:a", "aac",                        // Encode audio as AAC
            "-f", "rtsp",                         // Output format (RTSP)
            // "-f", "flv",                         // Output format (RTSP)
            "-rtsp_transport", "tcp",             // Use TCP for RTSP transport
            // "rtsp://your_rtsp_server_address:port/your_stream_name" // RTSP server URL
            target_link // RTSP server URL
        ])
        .stdin(Stdio::piped())                   // Send processed frames to FFmpeg's stdin
        .spawn()
}
