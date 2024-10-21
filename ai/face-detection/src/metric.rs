use std::marker::PhantomData;

use burn::{
    prelude::Backend,
    tensor::Tensor,
    train::metric::{
        state::{FormatOptions, NumericMetricState},
        Metric, MetricEntry, MetricMetadata, Numeric,
    },
};

#[derive(Default)]
pub struct IoUMetric<B: Backend> {
    state: NumericMetricState,
    // iou_threshold: f64, // Minimum IoU to consider a detection as correct.
    _b: PhantomData<B>,
}

pub struct IoUInput<B: Backend> {
    pub output: Tensor<B, 3>,
    pub targets: Tensor<B, 3>,
}

impl<B: Backend> IoUMetric<B> {
    pub fn new() -> Self {
        Self {
            state: NumericMetricState::default(),
            // iou_threshold,
            _b: PhantomData,
        }
    }

    fn calculate_iou(&self, pred_box: &[f64], target_box: &[f64]) -> f64 {
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

    fn update_batch(&mut self, pred_boxes: Tensor<B, 3>, target_boxes: Tensor<B, 3>) -> f64 {
        let [batch_size, _, _] = pred_boxes.dims();
        let mut correct_detections = 0.0;
        let pred_boxes = pred_boxes.flatten::<1>(0, 2).to_data();
        let pred_boxes = pred_boxes.as_slice::<f64>().unwrap();

        let target_boxes = target_boxes.flatten::<1>(0, 2).to_data();
        let target_boxes = target_boxes.as_slice::<f64>().unwrap();

        for image in pred_boxes.chunks(batch_size).zip(target_boxes.chunks(batch_size)) {
            let mut correct_detection_single = 0.0;
            for (pred_box, target_box) in image.0.chunks(4).zip(image.1.chunks(4)) {
                correct_detection_single += self.calculate_iou(pred_box, target_box);
            }
            correct_detections += correct_detection_single;
        }

        correct_detections / batch_size as f64

        //
        // for (pred_box, target_box) in pred_boxes.chunks(4).zip(target_boxes.chunks(4)) {
        //     correct_detections += self.calculate_iou(pred_box, target_box);
        // }
        //
        // correct_detections / (batch_size as f64 * num_boxes as f64)
    }
}

impl<B: Backend> Metric for IoUMetric<B> {
    const NAME: &'static str = "IoU Accuracy";

    type Input = IoUInput<B>;

    fn update(&mut self, input: &IoUInput<B>, _metadata: &MetricMetadata) -> MetricEntry {
        let accuracy = self.update_batch(input.output.clone(), input.targets.clone());

        self.state.update(
            100.0 * accuracy,
            input.output.dims()[0],
            FormatOptions::new(Self::NAME).unit("%").precision(2),
        )
    }

    fn clear(&mut self) {
        self.state.reset();
    }
}

impl<B: Backend> Numeric for IoUMetric<B> {
    fn value(&self) -> f64 {
        self.state.value()
    }
}
