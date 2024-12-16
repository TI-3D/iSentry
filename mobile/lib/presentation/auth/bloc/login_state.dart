import 'package:isentry/domain/entities/auth.dart';

/// Abstract state class for Login feature
abstract class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Auth auth;

  const LoginSuccess(this.auth);
}

class LoginFailure extends LoginState {
  final String errorMessage;

  const LoginFailure(this.errorMessage);
}

class SignupSuccess extends LoginState {}

class LogoutSuccess extends LoginState {}
