#![allow(unused_imports)]

use std::{path::PathBuf, str::FromStr};

use burn::{
    data::dataloader::DataLoaderBuilder, module::AutodiffModule, optim::{AdamConfig, GradientsParams, Optimizer, SgdConfig}, prelude::*, record::CompactRecorder, tensor::backend::AutodiffBackend, train::{
        metric::{AccuracyMetric, LossMetric},
        LearnerBuilder,
    }
};

use crate::{
    dataset::{DetectionBatcher, WiderFaceDataset},
    metric::IoUMetric,
    model::{Model, ModelConfig},
};

// impl<B: Backend> Model<B> {}

#[derive(Config)]
pub struct TrainingConfig {
    pub model: ModelConfig,
    pub optimizer: SgdConfig,
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

    let dataset_path = dotenvy::var("ISENTRY_DATASET_PATH").unwrap();
    let mut dataset_path = PathBuf::from_str(&dataset_path).unwrap();
    dataset_path.push("face-detection");

    let mut dataset_train_annotation = dataset_path.clone();
    dataset_train_annotation.push("train");
    dataset_train_annotation.push("annotation.txt");
    let dataloader_train = DataLoaderBuilder::new(batcher_train)
        .batch_size(config.batch_size)
        .shuffle(config.seed)
        .num_workers(config.num_workers)
        .build(WiderFaceDataset::new(dataset_train_annotation));

    let mut dataset_test_annotation = dataset_path.clone();
    dataset_test_annotation.push("test");
    dataset_test_annotation.push("annotation.txt");
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
        .with_file_checkpointer(CompactRecorder::new())
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

pub fn train_alt<B: AutodiffBackend>(
    artifact_dir: &str,
    config: TrainingConfig,
    device: B::Device,
) {
    create_artifact_dir(artifact_dir);
    config
        .save(format!("{artifact_dir}/config.json"))
        .expect("Config should be saved");

    B::seed(config.seed);
    // Create the model and optimizer.
    let mut model = config.model.init(&device);
    let mut optim = config.optimizer.init();

    let batcher_train = DetectionBatcher::<B>::new(device.clone());
    let batcher_valid = DetectionBatcher::<B::InnerBackend>::new(device.clone());

    let dataset_path = dotenvy::var("ISENTRY_DATASET_PATH").unwrap();
    let mut dataset_path = PathBuf::from_str(&dataset_path).unwrap();
    dataset_path.push("face-detection");

    let mut dataset_train_annotation = dataset_path.clone();
    dataset_train_annotation.push("train");
    dataset_train_annotation.push("annotation.txt");
    let dataloader_train = DataLoaderBuilder::new(batcher_train)
        .batch_size(config.batch_size)
        .shuffle(config.seed)
        .num_workers(config.num_workers)
        .build(WiderFaceDataset::new(dataset_train_annotation));

    let mut dataset_test_annotation = dataset_path.clone();
    dataset_test_annotation.push("test");
    dataset_test_annotation.push("annotation.txt");
    let dataloader_test = DataLoaderBuilder::new(batcher_valid)
        .batch_size(config.batch_size)
        .shuffle(config.seed)
        .num_workers(config.num_workers)
        .build(WiderFaceDataset::new(dataset_test_annotation));

    for epoch in 1..config.num_epochs + 1 {
        // Implement our training loop.
        for (iteration, batch) in dataloader_train.iter().enumerate() {
            // let output = model.forward(batch.images);
            let detection_output = model.forward_detection(batch.images, batch.targets.clone());
            // let loss: Tensor<B, 2> = detection_output.loss.clone().mean_dim(1).squeeze(1);
            // let loss: Tensor<B, 1> = loss.mean_dim(1).squeeze(1);
            let accuracy = accuracy(detection_output.output, batch.targets);

            println!("p");
            println!(
                "[Train - Epoch {} - Iteration {}] Loss {:.3} | Accuracy {:.3} %",
                epoch,
                iteration,
                detection_output.loss.clone().into_scalar(),
                accuracy,
            );

            // Gradients for the current backward pass
            let grads = detection_output.loss.backward();
            println!("grads1");
            // Gradients linked to each parameter of the model.
            let grads = GradientsParams::from_grads(grads, &model);
            println!("grads2");
            // Update the model using the optimizer.
            model = optim.step(config.learning_rate, model, grads);
            println!("optim.step");
        }

        let model_valid = model.valid();

        for (iteration, batch) in dataloader_test.iter().enumerate() {
            let detection_output = model_valid.forward_detection(batch.images, batch.targets.clone());
            // let loss: Tensor<B::InnerBackend, 2> = detection_output.loss.clone().mean_dim(1).squeeze(1);
            // let loss: Tensor<B::InnerBackend, 1> = loss.mean_dim(1).squeeze(1);
            let accuracy = accuracy(detection_output.output, batch.targets);

            println!(
                "[Valid - Epoch {} - Iteration {}] Loss {} | Accuracy {}",
                epoch,
                iteration,
                detection_output.loss.into_scalar(),
                accuracy,
            );
        }
    }

    model
        .save_file(format!("{artifact_dir}/model"), &CompactRecorder::new())
        .expect("Trained model should be saved");
}

fn create_artifact_dir(artifact_dir: &str) {
    // Remove existing artifacts before to get an accurate learner summary
    std::fs::remove_dir_all(artifact_dir).ok();
    std::fs::create_dir_all(artifact_dir).ok();
}

fn accuracy<B: Backend>(pred_boxes: Tensor<B, 3>, target_boxes: Tensor<B, 3>) -> f32 {
    let [batch_size, _, _] = pred_boxes.dims();
    let mut correct_detections = 0.0;
    let pred_boxes = pred_boxes.flatten::<1>(0, 2).to_data();
    println!("to_data");
    let pred_boxes = pred_boxes.as_slice::<f32>().unwrap();

    let target_boxes = target_boxes.flatten::<1>(0, 2).to_data();
    let target_boxes = target_boxes.as_slice::<f32>().unwrap();

    for image in pred_boxes
        .chunks(batch_size)
        .zip(target_boxes.chunks(batch_size))
    {
        let mut correct_detection_single = 0.0;
        for (pred_box, target_box) in image.0.chunks(4).zip(image.1.chunks(4)) {
            correct_detection_single += calculate_iou(pred_box, target_box);
        }
        correct_detections += correct_detection_single;
    }

    correct_detections / batch_size as f32

    //
    // for (pred_box, target_box) in pred_boxes.chunks(4).zip(target_boxes.chunks(4)) {
    //     correct_detections += self.calculate_iou(pred_box, target_box);
    // }
    //
    // correct_detections / (batch_size as f32 * num_boxes as f32)
}

fn calculate_iou(pred_box: &[f32], target_box: &[f32]) -> f32 {
    let (pred_x, pred_y, pred_w, pred_h) = (pred_box[0], pred_box[1], pred_box[2], pred_box[3]);

    let (target_x, target_y, target_w, target_h) =
        (target_box[0], target_box[1], target_box[2], target_box[3]);

    let inter_x1 = pred_x.max(target_x);
    let inter_y1 = pred_y.max(target_y);
    let inter_x2 = (pred_x + pred_w).min(target_x + target_w);
    let inter_y2 = (pred_y + pred_h).min(target_y + target_h);

    let inter_w = (inter_x2 - inter_x1).max(0.0); // Ensure non-negative
    let inter_h = (inter_y2 - inter_y1).max(0.0); // Ensure non-negative

    let inter_area = inter_w * inter_h;

    let pred_area = pred_w * pred_h;
    let target_area = target_w * target_h;

    let union_area = pred_area + target_area - inter_area;

    if union_area > 0.0 {
        inter_area / union_area
    } else {
        0.0
    }
}
