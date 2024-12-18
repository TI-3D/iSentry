import 'package:isentry/domain/entities/identity.dart';

class IdentityModel extends Identity {
  IdentityModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
    required super.key,
    required super.pictureSinglePath,
  });

  factory IdentityModel.fromJson(Map<String, dynamic> json) {
    final updateString = json['updatedAt'] as String;
    final updateDate = DateTime.parse(updateString);
    final createString = json['createdAt'] as String;
    final createDate = DateTime.parse(createString);

    final faces = json['faces'] as List<dynamic>? ?? [];
    final firstFace = faces.isNotEmpty ? faces.first : null;
    final pictureSinglePath =
        firstFace != null && firstFace['singlePictures'] != null
            ? firstFace['singlePictures']['path'] as String
            : '';

    return IdentityModel(
      id: json['id'] as int,
      name: json['name'] as String,
      pictureSinglePath: pictureSinglePath,
      updatedAt: DateTime(updateDate.year, updateDate.month, updateDate.day,
          updateDate.hour, updateDate.minute),
      createdAt: DateTime(createDate.year, createDate.month, createDate.day,
          createDate.hour, createDate.minute),
      key: json['key'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'key': key,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
