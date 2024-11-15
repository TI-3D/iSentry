use dlib_face_recognition::Rectangle;
use imageproc::rect::Rect;
use mysql::serde::Serialize;

#[derive(Serialize)]
pub struct BoundingBox {
    pub top: i32,
    pub left: i32,
    pub width: u32,
    pub height: u32,
}

impl From<&Rectangle> for BoundingBox {
    fn from(value: &Rectangle) -> Self {
        Self {
            top: value.top,
            left: value.left,
            width: (value.right - value.left) as u32,
            height: (value.bottom - value.top) as u32
        }
    }
}

impl From<&BoundingBox> for Rect {
    fn from(value: &BoundingBox) -> Self {
        Rect::at(value.left, value.top).of_size(value.width, value.height)
    }
}
