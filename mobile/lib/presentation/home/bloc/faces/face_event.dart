import 'package:equatable/equatable.dart';
import 'package:isentry/data/models/face_model.dart';

abstract class FaceEvent extends Equatable {
  const FaceEvent();

  @override
  List<Object> get props => [];
}

class LoadFaces extends FaceEvent {}

class LoadUnrecognizedFaces extends FaceEvent {}

class AddFace extends FaceEvent {
  final Face face;

  const AddFace(this.face);

  @override
  List<Object> get props => [face];
}

class UpdateFace extends FaceEvent {
  final Face face;

  const UpdateFace(this.face);

  @override
  List<Object> get props => [face];
}

class DeleteFace extends FaceEvent {
  final int id;

  const DeleteFace(this.id);

  @override
  List<Object> get props => [id];
}
