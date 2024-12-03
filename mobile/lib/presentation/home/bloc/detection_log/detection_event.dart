import 'package:equatable/equatable.dart';

abstract class DetectionEvent extends Equatable {
  const DetectionEvent();

  @override
  List<Object?> get props => [];
}

class GetDetectionById extends DetectionEvent {
  final String id;

  const GetDetectionById({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetAllDetection extends DetectionEvent {}

class DeleteDetection extends DetectionEvent {
  final String id;

  const DeleteDetection({required this.id});

  @override
  List<Object?> get props => [id];
}

class DetectionSubmitted extends DetectionEvent {
  final String face;

  const DetectionSubmitted({
    required this.face,
  });

  @override
  List<Object?> get props => [face];
}
