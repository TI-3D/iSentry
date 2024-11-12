use ab_glyph::{FontRef, PxScale};
use image::{Rgb, RgbImage};
use imageproc::drawing::{draw_hollow_rect_mut, draw_text_mut};

use super::bounding_box::BoundingBox;

pub trait LabelID {
    fn label(
        &mut self,
        rect: &BoundingBox,
        name: &str,
        font: &FontRef,
        font_height: f32,
        scale: PxScale,
    );
}

impl LabelID for RgbImage {
    fn label(
        &mut self,
        rect: &BoundingBox,
        name: &str,
        font: &FontRef,
        font_height: f32,
        scale: PxScale,
    ) {
        draw_hollow_rect_mut(self, rect.into(), Rgb([255, 0, 0]));
        draw_text_mut(
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
