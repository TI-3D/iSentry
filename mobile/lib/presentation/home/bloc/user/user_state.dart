import 'package:equatable/equatable.dart';
import 'package:isentry/data/models/user_model.dart';
import 'package:isentry/domain/entities/user.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserFailure extends UserState {
  final String errorMessage;

  UserFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class AllUserLoaded extends UserState {
  final List<UserModel> users;

  AllUserLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UserDeleted extends UserState {}

class AutoLogout extends UserState {}
