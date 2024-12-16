import 'package:equatable/equatable.dart';

abstract class IdentityEvent extends Equatable {
  const IdentityEvent();

  @override
  List<Object?> get props => [];
}

class GetAllIdentity extends IdentityEvent {}

class DeleteIdentity extends IdentityEvent {
  final String id;

  const DeleteIdentity({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdateKey extends IdentityEvent {
  final String id;
  final bool key;

  const UpdateKey({required this.id, required this.key});

  @override
  List<Object?> get props => [id];
}

class GetIdentityById extends IdentityEvent {
  final String id;

  const GetIdentityById({required this.id});

  @override
  List<Object?> get props => [id];
}
