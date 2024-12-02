import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/user_model.dart';
import 'package:isentry/presentation/home/bloc/user_event.dart';
import 'package:isentry/presentation/home/bloc/user_state.dart';
import 'package:http/http.dart' as http;

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<GetUserById>((event, emit) async {
      print("Fetching user with ID: ${event.id}");
      emit(UserLoading());

      try {
        final url = Uri.http(ipAddress, 'api/users/${event.id}');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          print('Decoded response: $data');
          if (data['success'] == true && data['data'] != null) {
            final user = UserModel.fromJson(data['data']);
            emit(UserLoaded(user));
          } else {
            emit(UserFailure(data['message'] ?? "User not found!"));
          }
        } else {
          emit(UserFailure(
              "Failed to fetch user data. Status code: ${response.statusCode}"));
        }
      } catch (e) {
        emit(UserFailure("Failed to fetch user: $e"));
      }
    });

    on<GetAllUser>((event, emit) async {
      emit(UserLoading());

      try {
        final url = Uri.http(ipAddress, 'api/users');
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          if (body['success']) {
            final allUsers = (body['data'] as List)
                .map((user) => UserModel.fromJson(user))
                .toList();
            emit(AllUserLoaded(allUsers));
          } else {
            emit(UserFailure(body['message'] ?? 'Failed to load users'));
          }
        } else {
          emit(UserFailure(
              'Failed to fetch users. Status code: ${response.statusCode}'));
        }
      } catch (e) {
        emit(UserFailure('Failed to fetch users: $e'));
      }
    });

    on<DeleteUser>((event, emit) async {
      emit(UserLoading());

      try {
        final url = Uri.http(ipAddress, 'api/users/${event.id}');
        final response = await http.delete(url);

        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          if (body['success']) {
            emit(UserDeleted());
            add(GetAllUser());
          } else {
            emit(UserFailure(body['message']));
          }
        } else {
          emit(UserFailure('${response.statusCode}'));
        }
      } catch (e) {
        emit(UserFailure('$e'));
      }
    });
  }
}
