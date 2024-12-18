import 'package:equatable/equatable.dart';
import 'package:share_plus/share_plus.dart';

abstract class FaceValidationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ValidateFaceEvent extends FaceValidationEvent {
  final XFile faceFile;

  ValidateFaceEvent({required this.faceFile});

  @override
  List<Object> get props => [faceFile];
}
