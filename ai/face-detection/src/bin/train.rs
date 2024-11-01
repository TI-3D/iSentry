use burn::{
    backend::{wgpu::WgpuDevice, Autodiff},
    optim::SgdConfig,
};
use face_detection::{ModelConfig, TrainingConfig};

fn main() {
    type MyBackend = burn::backend::Wgpu<f32, i32>;
    type MyAutodiffBackend = Autodiff<MyBackend>;

    let device = WgpuDevice::default();
    // burn::backend::wgpu::init_sync::<burn::backend::wgpu::Vulkan>(&device, Default::default());

    let artifact_dir = dotenvy::var("ISENTRY_ARTIFACT_DIR").unwrap();

    face_detection::train::<MyAutodiffBackend>(
        &artifact_dir,
        TrainingConfig::new(ModelConfig::new(), SgdConfig::new()),
        device.clone(),
    );
}
