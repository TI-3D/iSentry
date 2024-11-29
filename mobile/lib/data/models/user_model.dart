import 'package:isentry/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.username,
    required super.role,
    required super.ownerId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('Received JSON: $json');
    final user = json['user'];
    return UserModel(
      id: user['id'] as int,
      name: user['name'] as String,
      username: user['username'] as String,
      role: Role.values.byName(user['role'] as String),
      ownerId: user['ownerId'] != null ? user['ownerId'] as int : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'role': role.name,
    };
  }
}
