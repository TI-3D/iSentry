enum Role { OWNER, RESIDENT }

class Auth {
  final int id;
  final String username;
  final String name;
  final Role role;
  final String token;
  final String refreshToken;

  const Auth({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    required this.token,
    required this.refreshToken,
  });
}
