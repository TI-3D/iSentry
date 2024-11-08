use axum::{
    body::Body,
    http::{header::CONTENT_TYPE, HeaderMap},
    response::{IntoResponse, Response},
};
use image::RgbImage;

pub struct Image {
    #[allow(unused)]
    pub filename: String,
    pub data: RgbImage,
}

impl IntoResponse for Image {
    fn into_response(self) -> Response {
        let mut header = HeaderMap::new();
        header.append(CONTENT_TYPE, "image/jpeg".parse().unwrap());
        (header, Body::from(self.data.into_raw())).into_response()
    }
}
