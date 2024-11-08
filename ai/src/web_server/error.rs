use axum::{http::StatusCode, response::{IntoResponse, Response}};

pub enum WebError {
    NoImageFound,
    ChannelClosed
}

impl IntoResponse for WebError {
    fn into_response(self) -> Response {
        match self {
            WebError::NoImageFound => (StatusCode::NOT_ACCEPTABLE, "No image found").into_response(),
            WebError::ChannelClosed => (StatusCode::INTERNAL_SERVER_ERROR, "Model channel closed unexpectedly").into_response()
        }
    }
}
