import 'package:equatable/equatable.dart';

abstract class FaceEvent extends Equatable {
  const FaceEvent();

  @override
  List<Object> get props => [];
}

class LoadFaces extends FaceEvent {}

class LoadUnrecognizedFaces extends FaceEvent {}

class DeleteFace extends FaceEvent {
  final String id;

  const DeleteFace(this.id);

  @override
  List<Object> get props => [id];
}
