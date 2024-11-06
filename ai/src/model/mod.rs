#![allow(dead_code)]

use std::time::Instant;

use ab_glyph::{FontRef, PxScale};
// use ab_glyph::{FontRef, Scale};
use dlib_face_recognition::{
    FaceDetector, FaceDetectorTrait, FaceEncoderNetwork, FaceEncoderTrait, FaceEncoding,
    FaceLandmarks, ImageMatrix, LandmarkPredictor, LandmarkPredictorTrait, Point, Rectangle,
};
use image::{imageops::FilterType, DynamicImage, Rgb, RgbImage};
use imageproc::drawing::draw_text_mut;
use indentity::{Faces, Identities};
use mysql::{prelude::Queryable, Conn};
use tokio::sync::mpsc::Receiver;
use tracing::{error, info};
use utils::LabelID;

use crate::job::{Job, JobKind, JobResult};

mod face_detection;
mod indentity;
mod utils;

pub async fn run(opts: mysql::Opts, mut rx: Receiver<Job>) {
    let detector = FaceDetector::default();
    let Ok(landmark_predictor) = LandmarkPredictor::default() else {
        panic!("Error loading Landmark Predictor.");
    };
    let Ok(face_encoder) = FaceEncoderNetwork::default() else {
        panic!("Error loading Face Encoder.");
    };

    let mut db_conn = Conn::new(opts).unwrap();

    let stmt1 = db_conn.prep("INSERT INTO gallery_items (path, type, capture_method) VALUES (?1, \"PICTURE\", \"REGISTRATION\")").unwrap();
    let stmt2 = db_conn.prep("SELECT id, name, landmark FROM faces");
    let stmt3 = db_conn.prep("");

    let mut faces = Faces::default();
    let mut identities = Identities::default();

    if let Err(err) = db_conn.query_map::<(u64, [u8; 128], Option<u64>, Option<String>), _, _, _>(
        "
        SELECT faces.id as face_id, faces.embedding, identity.id, identity.name
        FROM faces
        LEFT JOIN identity 
        ON faces.identity = identity.id;
    ",
        |(face_id, embedding, identity_id, name)| {
            let embedding: Vec<f64> = bincode::deserialize(&embedding).unwrap();
            let embedding = FaceEncoding::from_vec(&embedding).unwrap();
            faces.insert(face_id, identity_id, embedding);
            if let Some(id) = identity_id {
                identities.insert(id, name.unwrap());
            }
        },
    ) {
        error!("{err}");
    };

    while let Some(job) = rx.recv().await {
        match job.kind {
            JobKind::Detection => (),
            JobKind::Recognition => (),
            JobKind::DetThenRec(bbox, face_enc, cropped_img, labelled_img) => {
                let image_matrix = ImageMatrix::from_image(&job.image);
                let faces = detector.face_locations(&image_matrix);
                let landmarks = faces
                    .iter()
                    .map(|face| landmark_predictor.face_landmarks(&image_matrix, face))
                    .collect::<Vec<FaceLandmarks>>();
                let embeddings =
                    face_encoder.get_face_encodings(&image_matrix, &landmarks, 0);

                let image = DynamicImage::ImageRgb8(job.image);

                let mut cropped_images =
                    Vec::with_capacity(if cropped_img { faces.len() } else { 0 });
                if cropped_img {
                    for face in faces.iter() {
                        cropped_images.push(
                            image
                                .crop_imm(
                                    face.left as u32,
                                    face.top as u32,
                                    (face.right - face.left) as u32,
                                    (face.bottom - face.top) as u32,
                                )
                                .into_rgb8(),
                        );
                    }
                }

                let mut image = image.to_rgb8();

                let font = FontRef::try_from_slice(include_bytes!(
                    "C:/Users/alimulap/Downloads/Montserrat/static/Montserrat-Medium.ttf"
                ))
                .unwrap();

                let name = "anomali#123";

                let font_height = 24.;
                let scale = PxScale {
                    x: font_height,
                    y: font_height,
                };
                for (bbox, face_encoded) in faces.iter().zip(embeddings.iter()) {
                    image.label(bbox, name, &font, font_height, scale);
                }

                if job
                    .tx
                    .send(JobResult::MBBnLandMWI(
                        bbox.then_some(faces),
                        face_enc.then_some(embeddings),
                        cropped_img.then_some(cropped_images),
                        labelled_img.then_some(image),
                    ))
                    .is_err()
                {
                    info!("Requester id: {} hung up before receiving data", job.id);
                }
            }
        }
    }
}

fn tick<R>(name: &str, f: impl Fn() -> R) -> R {
    let now = std::time::Instant::now();
    let result = f();
    println!("[{}] elapsed time: {}ms", name, now.elapsed().as_millis());
    result
}

pub fn example() {
    let first_photo = image::load_from_memory(include_bytes!(
        "C:/Users/alimulap/abyss/ai/dlib-face-recognition/examples/assets/obama_1.jpg"
    ))
    .unwrap();
    let first_photo = first_photo.resize(512, 512, FilterType::Gaussian).to_rgb8();
    let matrix_photo_1 = ImageMatrix::from_image(&first_photo);

    let second_photo = image::load_from_memory(include_bytes!(
        "C:/Users/alimulap/abyss/ai/dlib-face-recognition/examples/assets/obama_2.jpg"
    ))
    .unwrap();
    let second_photo = second_photo
        .resize(512, 512, FilterType::Gaussian)
        .to_rgb8();
    let matrix_photo_2 = ImageMatrix::from_image(&second_photo);

    let detector = FaceDetector::default();

    let Ok(landmarks) = LandmarkPredictor::default() else {
        panic!("Error loading Landmark Predictor.");
    };

    let Ok(face_encoder) = FaceEncoderNetwork::default() else {
        panic!("Error loading Face Encoder.");
    };

    let now = Instant::now();

    let face_locations_photo_1 = tick("FaceDetectorHog", || {
        detector.face_locations(&matrix_photo_1)
    });

    let face_locations_photo_2 = tick("FaceDetectorHog", || {
        detector.face_locations(&matrix_photo_2)
    });

    let face_1 = face_locations_photo_1.first().unwrap();
    let face_2 = face_locations_photo_2.first().unwrap();

    let landmarks_face_1 = tick("FaceLandmark", || {
        landmarks.face_landmarks(&matrix_photo_1, face_1)
    });
    let landmarks_face_2 = tick("FaceLandmark", || {
        landmarks.face_landmarks(&matrix_photo_2, face_2)
    });

    let encodings_face_1 = tick("FaceEncoding", || {
        face_encoder.get_face_encodings(&matrix_photo_1, &[landmarks_face_1.clone()], 0)
    });
    let encodings_face_2 = tick("FaceEncoding", || {
        face_encoder.get_face_encodings(&matrix_photo_2, &[landmarks_face_2.clone()], 0)
    });

    let first_face_measurements = encodings_face_1.first().unwrap();
    // let first_face_vec: Vec<f64> = first_face_measurements.to_vec();
    // let _first_face_bin = bincode::serialize(&first_face_vec).unwrap();
    // println!("{:?}", first_face_bin);

    let second_face_measurements = encodings_face_2.first().unwrap();

    let distance = tick("DistanceMeasure", || {
        second_face_measurements.distance(first_face_measurements)
    });

    println!("Euclidean distance of chosen faces: {distance}");

    println!("Entire thing elapsed time: {}ms", now.elapsed().as_millis());
}

fn draw_rectangle(image: &mut RgbImage, rect: &Rectangle, colour: Rgb<u8>) {
    for x in rect.left..rect.right {
        image.put_pixel(x as u32, rect.top as u32, colour);
        image.put_pixel(x as u32, rect.bottom as u32, colour);
    }

    for y in rect.top..rect.bottom {
        image.put_pixel(rect.left as u32, y as u32, colour);
        image.put_pixel(rect.right as u32, y as u32, colour);
    }
}

fn draw_point(image: &mut RgbImage, point: &Point, colour: Rgb<u8>) {
    image.put_pixel(point.x() as u32, point.y() as u32, colour);
    image.put_pixel(point.x() as u32 + 1, point.y() as u32, colour);
    image.put_pixel(point.x() as u32 + 1, point.y() as u32 + 1, colour);
    image.put_pixel(point.x() as u32, point.y() as u32 + 1, colour);
}

pub fn example2() {
    let mut image =
        image::open("C:/Users/alimulap/abyss/ai/dlib-face-recognition/examples/assets/obama_2.jpg")
            .unwrap()
            .to_rgb8();
    let matrix = ImageMatrix::from_image(&image);

    let detector = FaceDetector::default();

    let Ok(landmarks) = LandmarkPredictor::default() else {
        panic!("Unable to load landmark predictor!");
    };

    let red = Rgb([255, 0, 0]);

    let mut one_rect = None;

    let face_locations = tick("FaceDetector", || detector.face_locations(&matrix));

    for r in face_locations.iter() {
        println!("Abc");
        draw_rectangle(&mut image, r, red);

        one_rect = Some(*r);

        let landmarks = landmarks.face_landmarks(&matrix, r);
        for point in landmarks.iter() {
            draw_point(&mut image, point, red);
        }
    }

    // let mut image = ril::Image::<ril::Rgb>::from_bytes(ril::ImageFormat::Jpeg, image.as_raw()).unwrap();
    let mut image = RgbImage::from(image);

    let font = FontRef::try_from_slice(include_bytes!(
        "C:/Users/alimulap/Downloads/Montserrat/static/Montserrat-Medium.ttf"
    ))
    .unwrap();

    let text = "anomali#123";

    let height = 24.;
    let scale = PxScale {
        x: height,
        y: height,
    };

    let one_rect = one_rect.unwrap();

    draw_text_mut(
        &mut image,
        red,
        one_rect.left,
        one_rect.top - height as i32,
        scale,
        &font,
        text,
    );

    if let Err(e) = image
        .save("C:/Users/alimulap/abyss/ai/dlib-face-recognition/examples/assets/obama_2_out.jpg")
    {
        println!("Error saving the image: {e}");
    } else {
        println!(
            "Output image saved to C:/Users/alimulap/abyss/ai/dlib-face-recognition/examples/assets/obama_2_out.jpg"
        );
    }
}
