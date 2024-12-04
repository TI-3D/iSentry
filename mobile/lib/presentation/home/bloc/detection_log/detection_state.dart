import 'package:equatable/equatable.dart';
import 'package:isentry/data/models/detection_detail_model.dart';
import 'package:isentry/data/models/detection_model.dart';
import 'package:isentry/domain/entities/detection.dart';

abstract class DetectionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetectionInitial extends DetectionState {}

class DetectionLoading extends DetectionState {}

class DetectionLoaded extends DetectionState {
  final Detection detection;

  DetectionLoaded(this.detection);

  @override
  List<Object?> get props => [detection];
}

class DetectionFailure extends DetectionState {
  final String errorMessage;

  DetectionFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class AllDetectionLoaded extends DetectionState {
  final List<DetectionModel> detections;

  AllDetectionLoaded(this.detections);

  @override
  List<Object?> get props => [detections];
}

class DetectionDeleted extends DetectionState {}

class DetectionSuccess extends DetectionState {}

class DetailDetectionLoaded extends DetectionState {
  final List<DetectionDetailModel> recognizedDetails;
  final List<DetectionDetailModel> unrecognizedDetails;

  DetailDetectionLoaded(this.recognizedDetails, this.unrecognizedDetails);

  @override
  List<Object?> get props => [recognizedDetails, unrecognizedDetails];
}
