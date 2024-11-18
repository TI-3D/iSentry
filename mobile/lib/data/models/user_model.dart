import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String username;
  final Role role;

  const UserModel({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('Received JSON: $json');
    final user = json['user'];
    return UserModel(
      id: user['id'] as int,
      name: user['name'] as String,
      username: user['username'] as String,
      role: Role.values.byName(user['role'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'role': role,
    };
  }

  @override
  List<Object?> get props => [id, username, name, role];
}

enum Role {
  OWNER,
  RESIDENT,
}
