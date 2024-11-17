use std::{
    collections::HashMap,
    ops::{Deref, DerefMut},
};

use dlib_face_recognition::FaceEncoding;
use eyre::eyre;
use mysql::prelude::Queryable;

pub type Id = u64;

#[derive(Default)]
pub struct Faces(HashMap<Id, (Option<Id>, FaceEncoding)>);

#[derive(Default)]
pub struct Identities(HashMap<Id, String>);

pub fn update(
    db_conn: &mut mysql::Conn,
    faces: &mut Faces,
    identities: &mut Identities,
) -> eyre::Result<()> {
    for row in db_conn.query::<(u64, Vec<u8>, Option<u64>, Option<String>), _>(
        "
        SELECT faces.id as face_id, faces.embedding, identities.id, identities.name
        FROM faces
        LEFT JOIN identities 
        ON faces.identity = identities.id;
    ",
    )? {
        let (face_id, embedding, identity_id, name) = row;
        let embedding: Vec<f64> = bincode::deserialize(&embedding)?;
        if embedding.len() != 128 {
            return Err(eyre!("Embedding is not [f64; 128] for face_id: {}", face_id));
        }
        let embedding = FaceEncoding::from_vec(&embedding).unwrap();
        faces.insert(face_id, identity_id, embedding);
        if let Some(id) = identity_id {
            identities.insert(id, name.unwrap());
        }
    }
    Ok(())
}

impl Faces {
    pub fn insert(&mut self, id: Id, identity_id: Option<Id>, face: FaceEncoding) {
        self.0.insert(id, (identity_id, face));
    }

    /// returns (face_id, identity_id)
    pub fn identity(&self, other: &FaceEncoding) -> (Option<Id>, Option<Id>) {
        for (face_id, (identity, face)) in &self.0 {
            if face.distance(other) < 0.6 {
                return (Some(*face_id), *identity);
            }
        }
        (None, None)
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
