#![allow(unused_imports)]

use std::{path::PathBuf, str::FromStr};

use burn::{
    data::dataloader::DataLoaderBuilder,
    optim::AdamConfig,
    prelude::*,
    record::CompactRecorder,
    tensor::backend::AutodiffBackend,
    train::{
        metric::{AccuracyMetric, LossMetric},
        LearnerBuilder,
    },
};

use crate::{
    dataset::{DetectionBatcher, WiderFaceDataset, DATASET_PATH},
    metric::IoUMetric,
    model::{Model, ModelConfig},
};

impl<B: Backend> Model<B> {}

#[derive(Config)]
pub struct TrainingConfig {
    pub model: ModelConfig,
    pub optimizer: AdamConfig,
    #[config(default = 10)]
    pub num_epochs: usize,
    #[config(default = 64)]
    pub batch_size: usize,
    #[config(default = 4)]
    pub num_workers: usize,
    #[config(default = 42)]
    pub seed: u64,
    #[config(default = 1.0e-4)]
    pub learning_rate: f64,
}

pub fn train<B: AutodiffBackend>(artifact_dir: &str, config: TrainingConfig, device: B::Device) {
    create_artifact_dir(artifact_dir);
    config
        .save(format!("{artifact_dir}/config.json"))
        .expect("Config should be saved");

    B::seed(config.seed);

    let batcher_train = DetectionBatcher::<B>::new(device.clone());
    let batcher_valid = DetectionBatcher::<B::InnerBackend>::new(device.clone());

    let mut dataset_train_annotation = PathBuf::from_str(DATASET_PATH.as_str()).unwrap();
    dataset_train_annotation.push("train_annotation.txt");
    let dataloader_train = DataLoaderBuilder::new(batcher_train)
        .batch_size(config.batch_size)
        .shuffle(config.seed)
        .num_workers(config.num_workers)
        .build(WiderFaceDataset::new(dataset_train_annotation));

    let mut dataset_test_annotation = PathBuf::from_str(DATASET_PATH.as_str()).unwrap();
    dataset_test_annotation.push("test_annotation.txt");
    let dataloader_test = DataLoaderBuilder::new(batcher_valid)
        .batch_size(config.batch_size)
        .shuffle(config.seed)
        .num_workers(config.num_workers)
        .build(WiderFaceDataset::new(dataset_test_annotation));

    let learner = LearnerBuilder::new(artifact_dir)
        .metric_train_numeric(IoUMetric::new())
        .metric_valid_numeric(IoUMetric::new())
        .metric_train_numeric(LossMetric::new())
        .metric_valid_numeric(LossMetric::new())
        .devices(vec![device.clone()])
        .num_epochs(config.num_epochs)
        .summary()
        .build(
            config.model.init::<B>(&device),
            config.optimizer.init(),
            config.learning_rate,
        );

    let model_trained = learner.fit(dataloader_train, dataloader_test);

    model_trained
        .save_file(format!("{artifact_dir}/model"), &CompactRecorder::new())
        .expect("Trained model should be saved");
}

fn create_artifact_dir(artifact_dir: &str) {
    // Remove existing artifacts before to get an accurate learner summary
    std::fs::remove_dir_all(artifact_dir).ok();
    std::fs::create_dir_all(artifact_dir).ok();
}
