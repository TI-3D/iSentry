import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/user_model.dart';
import 'package:isentry/presentation/home/bloc/user/user_event.dart';
import 'package:isentry/presentation/home/bloc/user/user_state.dart';
import 'package:isentry/services/network_service.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<GetUserById>((event, emit) async {
      print("Fetching user with ID: ${event.id}");
      emit(UserLoading());

      try {
        final url = Uri.http(ipAddress, 'api/users/${event.id}');
        final response = await NetworkService.get(url.toString());

        if (response['success']) {
          UserModel user = UserModel.fromJson(response['data']);
          emit(UserLoaded(user));
        } else {
          if (response.statusCode == 403) {
            emit(AutoLogout());
          }
          emit(UserFailure(response['message']));
        }
      } catch (e) {
        if (e.toString().contains("Unauthorized access (403)")) {
          emit(AutoLogout());
        } else {
          emit(UserFailure("Failed to fetch user: $e"));
        }
      }
    });

    on<GetAllUser>((event, emit) async {
      emit(UserLoading());

      try {
        final url = Uri.http(ipAddress, 'api/users');
        final response = await NetworkService.get(url.toString());

        if (response['success']) {
          final allUsers = (response['data'] as List)
              .map((user) => UserModel.fromJson(user))
              .toList();
          emit(AllUserLoaded(allUsers));
        } else {
          emit(UserFailure(response['message'] ?? 'Failed to load users'));
        }
      } catch (e) {
        emit(UserFailure('Failed to fetch users: $e'));
      }
    });

    on<DeleteUser>((event, emit) async {
      print("Fetching user with ID: ${event.id}");
      emit(UserLoading());

      try {
        final url = Uri.http(ipAddress, 'api/users/${event.id}');
        final response = await NetworkService.delete(url.toString());

        if (response['success']) {
          emit(UserDeleted());
          add(GetAllUser());
        } else {
          emit(UserFailure(response['message']));
        }
      } catch (e) {
        emit(UserFailure("Failed to fetch user: $e"));
      }
    });
  }
}
