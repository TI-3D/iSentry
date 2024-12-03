class Face {
  final int id;
  final int? identityId;
  //final List<int> landmarks;
  //final List<int> boundingBox;
  final int pictureSingleId;
  final String pictureSinglePath;
  final int pictureFullId;
  final DateTime createdAt;
  // final DateTime updatedAt;

  Face({
    required this.id,
    required this.identityId,
    //required this.landmarks,
    //required this.boundingBox,
    required this.pictureSingleId,
    required this.pictureSinglePath,
    required this.pictureFullId,
    required this.createdAt,
    // required this.updatedAt,
  });

  factory Face.fromJson(Map<String, dynamic> json) {
    return Face(
      id: json['id'],
      identityId: json['identity'],
      //landmarks: List<int>.from(json['landmarks']),
      //boundingBox: List<int>.from(json['bounding_box']),
      pictureSingleId: json['picture_single'],
      pictureSinglePath: json['singlePictures']['path'],
      pictureFullId: json['picture_full'],
      createdAt: DateTime.parse(json['createdAt']),
      //updatedAt: DateTime.parse(json['updatedAt']),
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
