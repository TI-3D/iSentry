import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/user_model.dart';
import 'package:isentry/presentation/auth/bloc/login_event.dart';
import 'package:isentry/presentation/auth/bloc/login_state.dart';
import 'package:http/http.dart' as http;

class LoginBloc extends Bloc<AuthEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      emit(LoginLoading());
      try {
        var url = Uri.http(ipAddress, 'api/auth/login');
        var response = await http.post(url, body: {
          'username': event.username,
          'password': event.password,
        });

        var body = json.decode(response.body);

        if (body['success']) {
          UserModel user = UserModel.fromJson(body['data']);
          emit(LoginSuccess(user));
        } else {
          emit(const LoginFailure('Username atau Password salah'));
        }
      } catch (e, stackTrace) {
        debugPrint('error during login: $e');
        debugPrint('stackTrace: $stackTrace');
        emit(const LoginFailure('Terjadi kesalahan saat login'));
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
          'role': 'OWNER',
        });

        var body = json.decode(response.body);

        if (body['success']) {
          emit(SingupSuccess());
        } else {
          emit(const LoginFailure('Username sudah terdaftar'));
        }
      } catch (e, stackTrace) {
        debugPrint('error during login: $e');
        debugPrint('stackTrace: $stackTrace');
        emit(const LoginFailure('Terjadi kesalahan saat sigup'));
      }
    });
  }
}
