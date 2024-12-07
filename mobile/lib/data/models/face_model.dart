import 'package:isentry/domain/entities/face.dart';

class FaceModel extends Face {
  const FaceModel({
    required super.id,
    required super.identityId,
    // required super.landmarks,
    // required super.boundingBox,
    required super.pictureSingleId,
    required super.pictureSinglePath,
    required super.pictureFullId,
    required super.createdAt,
    // required super.updatedAt,
  });

  factory FaceModel.fromJson(Map<String, dynamic> json) {
    final createdAtString = json['createdAt'] as String;
    // final updatedAtString = json['updatedAt'] as String;

    final createdAtDate = DateTime.parse(createdAtString);
    // final updatedAtDate = DateTime.parse(updatedAtString);

    return FaceModel(
      id: json['id'] as int,
      identityId: json['identity'] as int?,
      // landmarks: List<int>.from(json['landmarks']),
      // boundingBox: List<int>.from(json['bounding_box']),
      pictureSingleId: json['picture_single'] as int,
      pictureSinglePath: json['singlePictures']['path'],
      pictureFullId: json['picture_full'] as int,
      createdAt: DateTime(createdAtDate.year, createdAtDate.month,
          createdAtDate.day, createdAtDate.hour, createdAtDate.minute),
      // updatedAt: DateTime(updatedAtDate.year, updatedAtDate.month,
      //     updatedAtDate.day, updatedAtDate.hour, updatedAtDate.minute),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'identity': identityId,
      // 'landmarks': landmarks,
      // 'bounding_box': boundingBox,
      'picture_single': pictureSingleId,
      'picture_full': pictureFullId,
      'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
