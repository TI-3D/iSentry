use std::env::var;
use std::sync::LazyLock;
use std::{fs, path::PathBuf};

use burn::{
    data::{dataloader::batcher::Batcher, dataset::Dataset},
    prelude::Backend,
    tensor::{Device, Tensor},
};
use image::{imageops::FilterType, GenericImage, GenericImageView, ImageBuffer};

static IMG_SIZE: u32 = 1024;

static MAX_FACES: usize = 20;

pub static DATASET_PATH: LazyLock<String> = LazyLock::new(|| var("ISENTRY_DATASET_PATH").unwrap());

pub struct WiderFaceDataset {
    items: Vec<WiderFaceDatasetItem>,
}

impl WiderFaceDataset {
    pub fn new(mut path: PathBuf) -> Self {
        let str = fs::read_to_string(path.clone()).unwrap();
        path.pop();
        let dataset_path = path;
        let mut items = Vec::new();
        let mut lines = str.lines();
        while let Some(img_path) = lines.next() {
            let num_faces = lines.next().unwrap().trim().parse::<usize>().unwrap();
            let mut faces: Vec<[i32; 4]> = Vec::new();
            for _ in 0..num_faces {
                faces.push(
                    lines
                        .next()
                        .unwrap()
                        .trim()
                        .split(' ')
                        .map(|str| str.parse::<i32>().unwrap())
                        .collect::<Vec<i32>>()[0..4]
                        .try_into()
                        .unwrap(),
                );
            }

            if faces.len() > MAX_FACES {
                faces.sort_by(|a, b| {
                    let area_a = a[2] * a[3];
                    let area_b = b[2] * b[3];
                    area_b.cmp(&area_a)
                });
                // will truncate for now
                faces.truncate(MAX_FACES);
            }

            let mut path = dataset_path.clone();
            path.push(img_path);

            items.push(WiderFaceDatasetItem {
                path: path.to_str().unwrap().to_string(),
                label: faces,
            })
        }
        Self { items: Vec::new() }
    }
}

#[derive(Debug, Clone)]
pub struct WiderFaceDatasetItem {
    path: String,
    label: Vec<[i32; 4]>,
}

impl WiderFaceDatasetItem {
    fn load_and_preprocess<B: Backend>(
        mut self,
        target_size: u32,
        device: &B::Device,
    ) -> (Tensor<B, 3>, Tensor<B, 2>) {
        let img = image::open(self.path).unwrap();

        let (org_w, org_h) = img.dimensions();

        let scale = target_size as f32 / org_w.max(org_h) as f32;
        let new_w = (org_w as f32 * scale) as u32;
        let new_h = (org_h as f32 * scale) as u32;

        let resized_img = img.resize(new_w, new_h, FilterType::CatmullRom);

        let mut padded_img =
            ImageBuffer::from_pixel(target_size, target_size, image::Rgba([0, 0, 0, 255]));

        let pad_x = (target_size - new_w) / 2;
        let pad_y = (target_size - new_h) / 2;

        padded_img
            .copy_from(&resized_img, pad_x, pad_y)
            .expect("failed to pad image");

        let img_data: Vec<f32> = padded_img
            .pixels()
            .flat_map(|p| p.0.iter().map(|&v| v as f32 / 255.0))
            .collect();

        let img_tensor = Tensor::<B, 3>::from_data(img_data.as_slice(), device).reshape([
            3,
            target_size as usize,
            target_size as usize,
        ]);

        let mut bbxs = Vec::new();

        for bbx in &mut self.label {
            bbxs.push(Self::adjust_bounding_box(
                *bbx,
                org_w,
                org_h,
                new_w,
                new_h,
                pad_x,
                pad_y,
                target_size,
            ));
        }

        while bbxs.len() < MAX_FACES {
            bbxs.push([0., 0., 0., 0.])
        }

        let targets =
            Tensor::<B, 2>::from_data(self.label.as_flattened(), device).reshape([MAX_FACES, 4]);

        (img_tensor, targets)
    }

    #[allow(clippy::too_many_arguments)]
    fn adjust_bounding_box(
        label: [i32; 4],
        org_w: u32,
        org_h: u32,
        new_w: u32,
        new_h: u32,
        pad_x: u32,
        pad_y: u32,
        target_size: u32,
    ) -> [f32; 4] {
        let scale_x = new_w as f32 / org_w as f32;
        let scale_y = new_h as f32 / org_h as f32;

        let [x, y, w, h] = label;
        let [x, y, w, h] = [x as f32, y as f32, w as f32, h as f32];

        let new_x = x * scale_x + pad_x as f32;
        let new_y = y * scale_y + pad_y as f32;
        let new_w = w * scale_x;
        let new_h = h * scale_y;

        let norm_x = new_x / target_size as f32;
        let norm_y = new_y / target_size as f32;
        let norm_w = new_w / target_size as f32;
        let norm_h = new_h / target_size as f32;

        [norm_x, norm_y, norm_w, norm_h]
    }
}

impl Dataset<WiderFaceDatasetItem> for WiderFaceDataset {
    fn get(&self, index: usize) -> Option<WiderFaceDatasetItem> {
        self.items.get(index).cloned()
    }

    fn len(&self) -> usize {
        self.items.len()
    }
}

const MEAN: [f32; 3] = [0.4914, 0.48216, 0.44653];
const STD: [f32; 3] = [0.24703, 0.24349, 0.26159];

#[derive(Clone)]
pub struct Normalizer<B: Backend> {
    pub mean: Tensor<B, 4>,
    pub std: Tensor<B, 4>,
}

impl<B: Backend> Normalizer<B> {
    pub fn new(device: &Device<B>) -> Self {
        let mean = Tensor::<B, 1>::from_floats(MEAN, device).reshape([1, 3, 1, 1]);
        let std = Tensor::<B, 1>::from_floats(STD, device).reshape([1, 3, 1, 1]);
        Self { mean, std }
    }

    pub fn normalize(&self, input: Tensor<B, 4>) -> Tensor<B, 4> {
        (input - self.mean.clone()) / self.std.clone()
    }
}

#[derive(Clone)]
pub struct DetectionBatcher<B: Backend> {
    normalizer: Normalizer<B>,
    device: B::Device,
}

#[derive(Debug, Clone)]
pub struct DetectionBatch<B: Backend> {
    pub images: Tensor<B, 4>,
    pub targets: Tensor<B, 3>,
}

impl<B: Backend> DetectionBatcher<B> {
    pub fn new(device: B::Device) -> Self {
        Self {
            normalizer: Normalizer::<B>::new(&device),
            device,
        }
    }
}

impl<B: Backend> Batcher<WiderFaceDatasetItem, DetectionBatch<B>> for DetectionBatcher<B> {
    fn batch(&self, mut items: Vec<WiderFaceDatasetItem>) -> DetectionBatch<B> {
        let mut images: Vec<Tensor<B, 3>> = Vec::with_capacity(items.len());
        let mut targets: Vec<Tensor<B, 2>> = Vec::with_capacity(items.len());

        while !items.is_empty() {
            let (image, target) = items
                .pop()
                .unwrap()
                .load_and_preprocess(IMG_SIZE, &self.device);
            images.push(image);
            targets.push(target);
        }

        let images: Tensor<B, 4> = Tensor::stack(images, 0);
        let images = self.normalizer.normalize(images);

        let targets: Tensor<B, 3> = Tensor::stack(targets, 0);
        DetectionBatch { images, targets }
    }
}
