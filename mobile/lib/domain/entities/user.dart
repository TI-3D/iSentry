import 'package:equatable/equatable.dart';

enum Role { OWNER, RESIDENT }

class User extends Equatable {
  final int id;
  final String name;
  final String username;
  final Role role;
  final int? ownerId;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    required this.ownerId,
  });

  @override
  List<Object?> get props => [id, name, username, role];
}
