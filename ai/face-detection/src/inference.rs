use burn::{
    config::Config,
    module::Module,
    prelude::Backend,
    record::{CompactRecorder, Recorder},
};

use crate::{Model, TrainingConfig};

pub fn infer<B: Backend>(artifact_dir: &str, device: B::Device) -> Model<B> {
    let config = TrainingConfig::load(format!("{artifact_dir}/config.json"))
        .expect("Config should exist for the model");
    let record = CompactRecorder::new()
        .load(format!("{artifact_dir}/model").into(), &device)
        .expect("Trained model should exist");

    config.model.init(&device).load_record(record)
}
