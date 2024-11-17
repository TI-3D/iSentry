import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int id;
  final String name;
  final String username;

  const UserModel({
    required this.id,
    required this.name,
    required this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    return UserModel(
      id: user['id'] as int,
      name: user['name'] as String,
      username: user['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
    };
  }

  @override
  List<Object?> get props => [id, username, name];
}
