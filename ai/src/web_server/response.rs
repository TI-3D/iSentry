use axum::{
    body::Body,
    http::{header::CONTENT_TYPE, HeaderMap},
    response::{IntoResponse, Response},
};
use image::RgbImage;
use serde::Serialize;

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

#[derive(Serialize)]
pub struct IPResponse {
    pub full_id: String,
    pub cropped_imgs: Vec<IPItem>,
}

#[derive(Serialize)]
pub struct IPItem {
    pub id: String,
    pub bounding_box: (i64, i64, u64, u64),
    pub embedding: Vec<f64>,
}

impl IntoResponse for IPResponse {
    fn into_response(self) -> Response {
        let mut header = HeaderMap::new();
        header.append(CONTENT_TYPE, "application/json".parse().unwrap());
        (header, serde_json::to_string(&self).unwrap()).into_response()
    }
}
