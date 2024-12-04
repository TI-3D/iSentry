import 'package:equatable/equatable.dart';
import 'package:isentry/data/models/face_model.dart';
import 'package:isentry/domain/entities/face.dart';

abstract class FaceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FaceInitial extends FaceState {}

class FaceLoading extends FaceState {}

class FaceLoaded extends FaceState {
  final Face face;

  FaceLoaded(this.face);

  @override
  List<Object?> get props => [face];
}

class FaceFailure extends FaceState {
  final String errorMessage;

  FaceFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class AllFaceLoaded extends FaceState {
  final List<FaceModel> faces;

  AllFaceLoaded(this.faces);

  @override
  List<Object?> get props => [faces];
}

class FaceDeleted extends FaceState {}

class FaceSuccess extends FaceState {}
