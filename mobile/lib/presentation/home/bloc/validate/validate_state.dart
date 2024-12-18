import 'package:equatable/equatable.dart';

abstract class FaceValidationState extends Equatable {
  @override
  List<Object> get props => [];
}

class FaceValidationInitial extends FaceValidationState {}

class FaceValidationLoading extends FaceValidationState {}

class FaceValidationSuccess extends FaceValidationState {
  final String faceId;

  FaceValidationSuccess({required this.faceId});

  @override
  List<Object> get props => [faceId];
}

class FaceValidationFailure extends FaceValidationState {
  final String error;

  FaceValidationFailure(this.error);

  @override
  List<Object> get props => [error];
}
