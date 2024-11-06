use std::collections::HashMap;

use dlib_face_recognition::FaceEncoding;

pub type Id = u64;

#[derive(Default)]
pub struct Identities(HashMap<Id, Identity>);

impl Identities {
    pub fn insert(&mut self, id: Id, name: String, face: FaceEncoding) {
        if let Some(identity) = self.0.get_mut(&id) {
            identity.insert(face)
        } else {
            self.0.insert(id, Identity { name, faces: vec![face] });
        }
    }
}

pub struct Identity {
    name: String,
    faces: Vec<FaceEncoding>,
}

impl Identity {
    fn new(name: String, faces: Vec<FaceEncoding>) -> Self {
        Self {
            name,
            faces
        }
    }

    fn insert(&mut self, face: FaceEncoding) {
        self.faces.push(face)
    }

    fn is_match(&self, other: &FaceEncoding) -> bool {
        self.faces.iter().any(|face| face.distance(other) < 0.6)
    }
}
