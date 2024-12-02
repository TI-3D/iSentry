import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/auth_model.dart';
import 'package:isentry/presentation/auth/bloc/login_event.dart';
import 'package:isentry/presentation/auth/bloc/login_state.dart';
import 'package:http/http.dart' as http;
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
        //var response = await http.post(url, body: {
        //  'username': event.username,
        //  'password': event.password,
        //});

        //var body = json.decode(response.body);

        if (response['success']) {
          AuthModel auth = AuthModel.fromJson(response['data']);
          String token = response['data']['token'].toString();
          String refreshToken = response['data']['token_refresh'];
          SecureStorageService.write("jwt_token", token);
          SecureStorageService.write("jwt_refresh_token", refreshToken);
          NetworkService.setToken(token);
          emit(LoginSuccess(auth));
        } else {
          emit(const LoginFailure('Incorrect username or password'));
        }
      } catch (e, stackTrace) {
        debugPrint('error during login: $e');
        debugPrint('stackTrace: $stackTrace');
        emit(const LoginFailure('Login failed'));
      }
    });

    on<LogoutRequested>((event, emit) {
      emit(LoginInitial());
    });

    on<SignupSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        var url = Uri.http(ipAddress, 'api/users');
        var response = await http.post(url, body: {
          'name': event.name,
          'username': event.username,
          'password': event.password,
          'role': event.role,
        });

        var body = json.decode(response.body);

        if (body['success']) {
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
