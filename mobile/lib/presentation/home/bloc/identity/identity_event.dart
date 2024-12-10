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
