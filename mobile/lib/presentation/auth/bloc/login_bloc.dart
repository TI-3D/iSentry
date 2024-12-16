import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/auth_model.dart';
import 'package:isentry/presentation/auth/bloc/login_event.dart';
import 'package:isentry/presentation/auth/bloc/login_state.dart';
import 'package:isentry/services/network_service.dart';
import 'package:isentry/services/secure_storage_service.dart';

class LoginBloc extends Bloc<AuthEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        var url = Uri.http(ipAddress, 'api/auth/login');
        var response = await NetworkService.post(url.toString(), body: {
          'username': event.username,
          'password': event.password,
        });

        if (response['success']) {
          AuthModel auth = AuthModel.fromJson(response['data']);
          String token = response['data']['token'].toString();
          String refreshToken = response['data']['token_refresh'];
          SecureStorageService.write("jwt_token", token);
          SecureStorageService.write("jwt_refresh_token", refreshToken);

          NetworkService.setToken(token);
          emit(LoginSuccess(auth));
          SecureStorageService.write("id", auth.id.toString());
          SecureStorageService.write("role", auth.role.name.toString());
        } else {
          emit(const LoginFailure('Incorrect username or password'));
        }
      } catch (e, stackTrace) {
        debugPrint('error during login: $e');
        debugPrint('stackTrace: $stackTrace');
        emit(const LoginFailure('Incorect Username or Password'));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        var url = Uri.http(ipAddress, 'api/auth/logout/${event.id}');
        var response = await NetworkService.post(url.toString());

        if (response['success']) {
          SecureStorageService.deleteAll;
          emit(LogoutSuccess());
        } else {
          emit(const LoginFailure('User not found'));
        }
      } catch (e, stackTrace) {
        debugPrint('error during login: $e');
        debugPrint('stackTrace: $stackTrace');
        emit(const LoginFailure('Logout failed'));
      }
    });

    on<SignupSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        var url = Uri.http(ipAddress, 'api/users');
        var response = await NetworkService.post(url.toString(), body: {
          'name': event.name,
          'username': event.username,
          'password': event.password,
          'role': event.role,
          'ownerId': event.ownerId,
          'identityId': event.identityId,
        });

        if (response['success']) {
          emit(SignupSuccess());
        } else {
          emit(const LoginFailure('Username is already registered'));
        }
      } catch (e, stackTrace) {
        debugPrint('error during login: $e');
        debugPrint('stackTrace: $stackTrace');
        emit(const LoginFailure('Sign up failed'));
      }
    });
  }
}
