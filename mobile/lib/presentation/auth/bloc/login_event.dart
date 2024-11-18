import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginSubmitted extends AuthEvent {
  final String username;
  final String password;

  const LoginSubmitted({required this.username, required this.password});

  @override
  List<Object?> get props => [username, password];
}

class LogoutRequested extends AuthEvent {}

class SignupSubmitted extends AuthEvent {
  final String name;
  final String username;
  final String password;

  const SignupSubmitted(
      {required this.name, required this.username, required this.password});

  @override
  List<Object?> get props => [name, username, password];
}