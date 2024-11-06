use ab_glyph::{FontRef, PxScale};
use image::{Rgb, RgbImage};
use imageproc::{
    drawing::{draw_hollow_rect, draw_text},
    rect::Rect,
};

type DlibRectangle = dlib_face_recognition::Rectangle;

pub trait LabelID {
    fn label(
        &mut self,
        rect: &DlibRectangle,
        name: &str,
        font: &FontRef,
        font_height: f32,
        scale: PxScale,
    );
}

impl LabelID for RgbImage {
    fn label(
        &mut self,
        rect: &DlibRectangle,
        name: &str,
        font: &FontRef,
        font_height: f32,
        scale: PxScale,
    ) {
        draw_hollow_rect(self, Rectangle(rect).into(), Rgb([255, 0, 0]));
        draw_text(
            self,
            Rgb([255, 0, 0]),
            rect.left,
            rect.top - font_height as i32,
            scale,
            font,
            name,
        );
    }
}

struct Rectangle<'a>(&'a DlibRectangle);

impl<'a> Into<Rect> for Rectangle<'a> {
    fn into(self) -> Rect {
        Rect::at(self.0.left, self.0.top).of_size(
            (self.0.right - self.0.left) as u32,
            (self.0.bottom - self.0.top) as u32,
        )
    }
}
