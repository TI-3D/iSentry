use std::{collections::HashMap, ops::{Deref, DerefMut}};

use dlib_face_recognition::FaceEncoding;

pub type Id = u64;

#[derive(Default)]
pub struct Faces(HashMap<Id, (Option<Id>, FaceEncoding)>);

#[derive(Default)]
pub struct Identities(HashMap<Id, String>);

impl Faces {
    pub fn insert(&mut self, id: Id, identity_id: Option<Id>, face: FaceEncoding) {
        self.0.insert(id, (identity_id, face));
    }

    pub fn identity(&self, other: &FaceEncoding) -> Option<Id> {
        for (identity, face) in self.0.values() {
            if face.distance(other) < 0.6 {
                return *identity
            }
        }
        None
    }
}

impl Deref for Identities {
    type Target = HashMap<Id, String>;
    fn deref(&self) -> &Self::Target {
        &self.0
    }
}

impl DerefMut for Identities {
    fn deref_mut(&mut self) -> &mut Self::Target {
        &mut self.0
    }
}
