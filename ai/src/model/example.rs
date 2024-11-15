use std::time::Instant;

use ab_glyph::{FontRef, PxScale};
use dlib_face_recognition::{FaceDetector, FaceDetectorTrait, FaceEncoderNetwork, FaceEncoderTrait, ImageMatrix, LandmarkPredictor, LandmarkPredictorTrait, Point, Rectangle};
use image::{imageops::FilterType, Rgb, RgbImage};
use imageproc::drawing::draw_text_mut;


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
