import 'package:equatable/equatable.dart';

abstract class DetailIdentityEvent extends Equatable {
  const DetailIdentityEvent();

  @override
  List<Object?> get props => [];
}

class GetAllIdentity extends DetailIdentityEvent {}

class DeleteIdentity extends DetailIdentityEvent {
  final String id;

  const DeleteIdentity({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdateKey extends DetailIdentityEvent {
  final String id;
  final bool key;

  const UpdateKey({required this.id, required this.key});

  @override
  List<Object?> get props => [id];
}

class UpdateName extends DetailIdentityEvent {
  final String id;
  final String name;

  const UpdateName({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class GetIdentityById extends DetailIdentityEvent {
  final String id;

  const GetIdentityById({required this.id});

  @override
  List<Object?> get props => [id];
}
