import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class GetUserById extends UserEvent {
  final String id;

  const GetUserById({required this.id});

  @override
  List<Object?> get props => [id];
}

class GetAllUser extends UserEvent {}

class DeleteUser extends UserEvent {
  final int id;

  const DeleteUser({required this.id});

  @override
  List<Object?> get props => [id];
}
