import 'package:equatable/equatable.dart';
import 'package:isentry/data/models/identity_model.dart';
import 'package:isentry/domain/entities/identity.dart';

abstract class IdentityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class IdentityInitial extends IdentityState {}

class IdentityLoading extends IdentityState {}

class AllIdentityLoaded extends IdentityState {
  final List<IdentityModel> identities;

  AllIdentityLoaded(this.identities);

  @override
  List<Object?> get props => [identities];
}

class IdentityFailure extends IdentityState {
  final String errorMessage;

  IdentityFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class IdentityDeleted extends IdentityState {}

class KeyUpdated extends IdentityState {
  final String id;
  final bool key;

  KeyUpdated({required this.id, required this.key});

  @override
  List<Object?> get props => [id, key];
}

class IdentityLoaded extends IdentityState {
  final Identity identities;

  IdentityLoaded(this.identities);

  @override
  List<Object?> get props => [identities];
}
