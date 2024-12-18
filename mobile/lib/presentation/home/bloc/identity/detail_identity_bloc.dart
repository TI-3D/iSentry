import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/identity_model.dart';
import 'package:isentry/presentation/home/bloc/identity/detail_identity_event.dart';
import 'package:isentry/presentation/home/bloc/identity/detail_identity_state.dart';
import 'package:isentry/services/network_service.dart';

class DetailIdentityBloc
    extends Bloc<DetailIdentityEvent, DetailIdentityState> {
  DetailIdentityBloc() : super(IdentityInitial()) {
    on<GetIdentityById>((event, emit) async {
      emit(IdentityLoading());

      try {
        final url = Uri.http(ipAddress, 'api/identities/${event.id}');
        final response = await NetworkService.get(url.toString());

        if (response['success']) {
          IdentityModel identities = IdentityModel.fromJson(response['data']);
          emit(IdentityLoaded(identities));
        } else {
          emit(IdentityFailure(response['message']));
        }
      } catch (e) {
        emit(IdentityFailure("Failed to fetch user: $e"));
      }
    });

    on<UpdateKey>((event, emit) async {
      emit(IdentityLoading());

      try {
        final url = Uri.http(ipAddress, 'api/identities/${event.id}');
        final response = await NetworkService.patch(url.toString(), body: {
          'key': event.key,
        });

        if (response['success']) {
          emit(KeyUpdated(id: event.id, key: event.key));
        } else {
          emit(IdentityFailure(response['message']));
        }
      } catch (e) {
        emit(IdentityFailure("Failed to fetch user: $e"));
      }
    });

    on<UpdateName>((event, emit) async {
      emit(IdentityLoading());

      try {
        final url = Uri.http(ipAddress, 'api/identities/${event.id}');
        final response = await NetworkService.patch(url.toString(), body: {
          'name': event.name,
        });

        if (response['success']) {
          emit(NameUpdated(id: event.id, name: event.name));
        } else {
          emit(IdentityFailure(response['message']));
        }
      } catch (e) {
        emit(IdentityFailure("Failed to fetch user: $e"));
      }
    });
  }
}
