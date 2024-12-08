import 'package:isentry/domain/entities/identity.dart';

class IdentityModel extends Identity {
  IdentityModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
  });

  factory IdentityModel.fromJson(Map<String, dynamic> json) {
    final updateString = json['updatedAt'] as String;
    final updateDate = DateTime.parse(updateString);
    final createString = json['createdAt'] as String;
    final createDate = DateTime.parse(createString);

    return IdentityModel(
      id: json['id'] as int,
      name: json['name'] as String,
      updatedAt: DateTime(updateDate.year, updateDate.month, updateDate.day,
          updateDate.hour, updateDate.minute),
      createdAt: DateTime(createDate.year, createDate.month, createDate.day,
          createDate.hour, createDate.minute),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
