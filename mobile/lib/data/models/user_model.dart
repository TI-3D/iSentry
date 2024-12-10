import 'package:isentry/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.username,
    required super.identityId,
    required super.role,
    required super.ownerId,
    required super.createAt,
    required super.updateAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final createdAtString = json['createdAt'] as String;
    final updatedAtString = json['updatedAt'] as String;

    final createdAtDate = DateTime.parse(createdAtString);
    final updatedAtDate = DateTime.parse(updatedAtString);

    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      identityId: json['identityId'] as int?,
      role: Role.values.byName(json['role'] as String),
      ownerId: json['ownerId'] as int?,
      createAt: DateTime(createdAtDate.year, createdAtDate.month,
          createdAtDate.day, createdAtDate.hour, createdAtDate.minute),
      updateAt: DateTime(updatedAtDate.year, updatedAtDate.month,
          updatedAtDate.day, updatedAtDate.hour, updatedAtDate.minute),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'identityId': identityId,
      'role': role,
      'ownerId': ownerId,
      'createAt': createAt.toIso8601String(),
      'updateAt': updateAt.toIso8601String(),
    };
  }
}
