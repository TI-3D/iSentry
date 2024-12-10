// ignore: constant_identifier_names
enum Role { OWNER, RESIDENT }

class User {
  final int id;
  final String name;
  final String username;
  final int? identityId;
  final Role role;
  final int? ownerId;
  final DateTime createAt;
  final DateTime updateAt;

  const User({
    required this.id,
    required this.name,
    required this.username,
    this.identityId,
    required this.role,
    this.ownerId,
    required this.createAt,
    required this.updateAt,
  });
}
