use std::process::Stdio;

use tokio::{
    io,
    process::{Child, Command},
};
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
            "-hide_banner", "-loglevel", "error",
            "-framerate", "30",                   // Set frame rate
            "-f", "rawvideo",                     // Raw video format
            "-pix_fmt", "rgb24",                  // Pixel format (RGB)
            "-s", &format!("{}x{}", 1920, 1080),// Frame size
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
