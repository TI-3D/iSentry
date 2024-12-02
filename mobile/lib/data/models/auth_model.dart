import 'package:isentry/domain/entities/auth.dart';

class AuthModel extends Auth {
  const AuthModel({
    required super.id,
    required super.name,
    required super.username,
    required super.role,
    required super.token,
    required super.refreshToken,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    print('Received JSON: $json');
    final user = json['user'];
    return AuthModel(
      id: user['id'] as int,
      name: user['name'] as String,
      username: user['username'] as String,
      role: Role.values.byName(user['role'] as String),
      token: json['token'] as String,
      refreshToken: json['token_refresh'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'role': role.name,
      'token': token,
      'token_refresh': refreshToken,
    };
  }
}
