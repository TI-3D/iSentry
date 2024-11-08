// use std::{env, fs::File};
//
// use burn::{backend::{wgpu::WgpuDevice, Autodiff}, tensor::Tensor};
// use image::GenericImageView;

fn main() {
    // type MyBackend = burn::backend::Wgpu<f32, i32>;
    // type MyAutodiffBackend = Autodiff<MyBackend>;
    //
    // let device = WgpuDevice::default();
    //
    // let artifact_dir = dotenvy::var("ISENTRY_ARTIFACT_DIR").unwrap();
    //
    // let model = face_detection::infer::<MyAutodiffBackend>(&artifact_dir, device);
    //
    // let img_path = &env::args().collect::<Vec<String>>()[1];
    //
    // let img = image::open(img_path).unwrap();
    //
    // let img_tensor = Tensor::from_data(img.pixels().map(|p|), device)
}
