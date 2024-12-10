import 'package:equatable/equatable.dart';
import 'package:isentry/data/models/identity_model.dart';

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
