use burn::{
    prelude::*,
    tensor::backend::AutodiffBackend,
    train::{
        metric::{Adaptor, LossInput},
        TrainOutput, TrainStep, ValidStep,
    },
};
use nn::{
    conv::{Conv2d, Conv2dConfig},
    loss::MseLoss,
    pool::{AdaptiveAvgPool2d, AdaptiveAvgPool2dConfig},
    Dropout, DropoutConfig, Linear, LinearConfig, Relu,
};

use crate::{dataset::DetectionBatch, metric::IoUInput};

#[derive(Module, Debug)]
pub struct Model<B: Backend> {
    conv1: Conv2d<B>,
    conv2: Conv2d<B>,
    pool: AdaptiveAvgPool2d,
    dropout: Dropout,
    linear1: Linear<B>,
    linear2: Linear<B>,
    activation: Relu,
    num_boxes: usize, // max_faces
}

#[derive(Config, Debug)]
pub struct ModelConfig {
    #[config(default = "128")]
    hidden_size: usize,
    #[config(default = "20")]
    max_faces: usize,// Set the max number of faces (boxes) to predict
    #[config(default = "0.5")]
    dropout: f64,
}

impl ModelConfig {
    pub fn init<B: Backend>(&self, device: &B::Device) -> Model<B> {
        Model {
            num_boxes: self.max_faces, 
            conv1: Conv2dConfig::new([3, 8], [3, 3]).init(device),
            conv2: Conv2dConfig::new([8, 16], [3, 3]).init(device),
            pool: AdaptiveAvgPool2dConfig::new([8, 8]).init(),
            activation: Relu::new(),
            dropout: DropoutConfig::new(self.dropout).init(),
            linear1: LinearConfig::new(16 * 8 * 8, self.hidden_size).init(device),
            linear2: LinearConfig::new(self.hidden_size, self.max_faces * 4).init(device),
        }
    }
}

impl<B: Backend> Model<B> {
    /// Forward pass for face detection.
    /// # Inputs:
    ///   - `images` [batch_size, channels, height, width]
    /// # Outputs:
    ///   - Bounding box coordinates [batch_size, num_boxes, 4]
    pub fn forward(&self, images: Tensor<B, 4>) -> Tensor<B, 3> {
        // Pass through the first convolutional layer.
        let x = self.conv1.forward(images); // [batch_size, 8, _, _]
        let x = self.activation.forward(x);
        let x = self.dropout.forward(x);

        // Pass through the second convolutional layer.
        let x = self.conv2.forward(x); // [batch_size, 16, _, _]
        let x = self.activation.forward(x);
        let x = self.dropout.forward(x);

        // Adaptive pooling layer to make the output a fixed size.
        let x = self.pool.forward(x); // [batch_size, 16, 8, 8]
        let batch_size = x.dims()[0];
        let x = x.reshape([batch_size, 16 * 8 * 8]); // Flatten [batch_size, 16*8*8]

        // Fully connected layers.
        let x = self.linear1.forward(x); // [batch_size, hidden_size]
        let x = self.activation.forward(x);
        let x = self.dropout.forward(x);

        // Final output predicting bounding boxes.
        let output = self.linear2.forward(x); // [batch_size, num_boxes * 4]
        output.reshape([batch_size, self.num_boxes, 4]) // Reshape to [batch_size, num_boxes, 4]
    }

    pub fn forward_detection(
        &self,
        images: Tensor<B, 4>,
        targets: Tensor<B, 3>,
    ) -> DetectionOutput<B> {
        let output = self.forward(images);
        let loss = MseLoss::new().forward_no_reduction(output.clone(), targets.clone());

        DetectionOutput {
            loss,
            output,
            targets,
        }
    }
}

pub struct DetectionOutput<B: Backend> {
    pub loss: Tensor<B, 3>,
    pub output: Tensor<B, 3>,
    pub targets: Tensor<B, 3>,
}

impl<B: Backend> DetectionOutput<B> {
    pub fn compute_mean_loss(&self) -> Tensor<B, 1> {
        let loss: Tensor<B, 2> = self.loss.clone().mean_dim(1).squeeze(1);
        loss.mean_dim(1).squeeze(1)
    }
}

impl<B: Backend> Adaptor<IoUInput<B>> for DetectionOutput<B> {
    fn adapt(&self) -> IoUInput<B> {
        IoUInput {
            output: self.output.clone(),
            targets: self.targets.clone(),
        }
    }
}

impl<B: Backend> Adaptor<LossInput<B>> for DetectionOutput<B> {
    fn adapt(&self) -> LossInput<B> {
        LossInput::new(self.compute_mean_loss())
    }
}

impl<B: AutodiffBackend> TrainStep<DetectionBatch<B>, DetectionOutput<B>> for Model<B> {
    fn step(&self, item: DetectionBatch<B>) -> TrainOutput<DetectionOutput<B>> {
        let item = self.forward_detection(item.images, item.targets);

        TrainOutput::new(self, item.loss.backward(), item)
    }
}

impl<B: Backend> ValidStep<DetectionBatch<B>, DetectionOutput<B>> for Model<B> {
    fn step(&self, item: DetectionBatch<B>) -> DetectionOutput<B> {
        self.forward_detection(item.images, item.targets)
    }
}
