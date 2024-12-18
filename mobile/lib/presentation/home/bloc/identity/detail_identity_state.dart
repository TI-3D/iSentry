import 'package:equatable/equatable.dart';
import 'package:isentry/data/models/identity_model.dart';
import 'package:isentry/domain/entities/identity.dart';

abstract class DetailIdentityState extends Equatable {
  @override
  List<Object?> get props => [];
}

class IdentityInitial extends DetailIdentityState {}

class IdentityLoading extends DetailIdentityState {}

class AllIdentityLoaded extends DetailIdentityState {
  final List<IdentityModel> identities;

  AllIdentityLoaded(this.identities);

  @override
  List<Object?> get props => [identities];
}

class IdentityFailure extends DetailIdentityState {
  final String errorMessage;

  IdentityFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class IdentityDeleted extends DetailIdentityState {}

class KeyUpdated extends DetailIdentityState {
  final String id;
  final bool key;

  KeyUpdated({required this.id, required this.key});

  @override
  List<Object?> get props => [id, key];
}

class IdentityLoaded extends DetailIdentityState {
  final Identity identities;

  IdentityLoaded(this.identities);

  @override
  List<Object?> get props => [identities];
}
