import 'package:equatable/equatable.dart';

abstract class FaceEvent extends Equatable {
  const FaceEvent();

  @override
  List<Object?> get props => [];
}

class GetFaceById extends FaceEvent {
  final String id;

  const GetFaceById({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetAllFace extends FaceEvent {}

class DeleteFace extends FaceEvent {
  final int id;

  const DeleteFace({required this.id});

  @override
  List<Object?> get props => [id];
}

class FaceSubmitted extends FaceEvent {
  final int identityId;
  final List<int> landmarks;
  final List<int> boundingBox;
  final int pictureSingleId;
  final int pictureFullId;

  const FaceSubmitted({
    required this.identityId,
    required this.landmarks,
    required this.boundingBox,
    required this.pictureSingleId,
    required this.pictureFullId,
  });

  @override
  List<Object?> get props => [
        identityId,
        landmarks,
        boundingBox,
        pictureSingleId,
        pictureFullId,
      ];
}
