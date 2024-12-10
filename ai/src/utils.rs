use ab_glyph::{FontRef, PxScale};
use image::{Rgb, RgbImage, GenericImageView, ImageBuffer};
use imageproc::drawing::{draw_hollow_rect_mut, draw_text_mut};

use crate::model::bounding_box::BoundingBox;

pub type DetectionOutput = (String, u64, u64);

pub enum Msg {
    Error,
}

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



pub fn resize_and_pad_image(
    img: &image::DynamicImage,
    target_width: u32,
    target_height: u32,
    padding_color: Rgb<u8>,
) -> image::RgbImage {
    // Original dimensions
    let (width, height) = img.dimensions();
    let aspect_ratio = width as f32 / height as f32;
    let target_aspect_ratio = target_width as f32 / target_height as f32;

    // Determine new dimensions
    let (new_width, new_height) = if aspect_ratio > target_aspect_ratio {
        // Image is wider than target
        (
            target_width,
            (target_width as f32 / aspect_ratio).round() as u32,
        )
    } else {
        // Image is taller than target
        (
            (target_height as f32 * aspect_ratio).round() as u32,
            target_height,
        )
    };

    // Resize the image
    let resized_img = img.resize_exact(new_width, new_height, image::imageops::FilterType::Lanczos3);

    // Create a blank image with the target dimensions and padding color
    let mut output_img = ImageBuffer::from_pixel(target_width, target_height, padding_color);

    // Calculate offsets for centering the resized image
    let x_offset = (target_width - new_width) / 2;
    let y_offset = (target_height - new_height) / 2;

    // Overlay the resized image onto the blank canvas
    image::imageops::overlay(&mut output_img, &resized_img.to_rgb8(), x_offset as i64, y_offset as i64);

    output_img
}
