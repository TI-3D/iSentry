import 'package:equatable/equatable.dart';
import 'package:isentry/data/models/face_model.dart';

abstract class FaceState extends Equatable {
  const FaceState();

  @override
  List<Object> get props => [];
}

class FaceInitial extends FaceState {}

class FaceLoading extends FaceState {}

class FaceLoaded extends FaceState {
  final List<FaceModel> faces;

  const FaceLoaded(this.faces);

  @override
  List<Object> get props => [faces];
}

class FaceError extends FaceState {
  final String message;

  const FaceError(this.message);

  @override
  List<Object> get props => [message];
}
