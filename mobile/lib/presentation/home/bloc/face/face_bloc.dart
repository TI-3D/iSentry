import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/face_model.dart';
import 'package:isentry/presentation/home/bloc/face/face_event.dart';
import 'package:isentry/presentation/home/bloc/face/face_state.dart';
import 'package:isentry/services/network_service.dart';

class FaceBloc extends Bloc<FaceEvent, FaceState> {
  FaceBloc() : super(FaceInitial()) {
    on<GetFaceById>((event, emit) async {
      print("Fetching user with ID: ${event.id}");
      emit(FaceLoading());

      try {
        final url = Uri.http(ipAddress, 'api/faces/${event.id}');
        final response = await NetworkService.get(url.toString());

        if (response['success']) {
          FaceModel detection = FaceModel.fromJson(response['data']);
          emit(FaceLoaded(detection));
        } else {
          emit(FaceFailure(response['message']));
        }
      } catch (e) {
        emit(FaceFailure("Failed to fetch user: $e"));
      }
    });

    on<GetAllFace>((event, emit) async {
      emit(FaceLoading());

      try {
        final url = Uri.http(ipAddress, 'api/faces');
        final response = await NetworkService.get(url.toString());

        if (response['success']) {
          final allDetections = (response['data'] as List)
              .map((detection) => FaceModel.fromJson(detection))
              .toList();
          emit(AllFaceLoaded(allDetections));
        } else {
          emit(FaceFailure(response['message'] ?? 'Failed to load users'));
        }
      } catch (e) {
        emit(FaceFailure('Failed to fetch users: $e'));
      }
    });

    on<DeleteFace>((event, emit) async {
      emit(FaceLoading());

      try {
        final url = Uri.http(ipAddress, 'api/faces/${event.id}');
        final response = await NetworkService.delete(url.toString());

        if (response['success']) {
          emit(FaceDeleted());
          add(GetAllFace());
        } else {
          emit(FaceFailure(response['message']));
        }
      } catch (e) {
        emit(FaceFailure("Failed to fetch user: $e"));
      }
    });

    on<FaceSubmitted>((event, emit) async {
      emit(FaceLoading());
      try {
        var url = Uri.http(ipAddress, 'api/faces');
        var response = await NetworkService.post(url.toString(), body: {
          'identity': event.identityId,
          'embedding': event.landmarks,
          'pictureFull': event.pictureFullId,
          'pictureSingle': event.pictureSingleId,
          'boundingBox': event.boundingBox,
        });

        if (response['success']) {
          emit(FaceSuccess());
        } else {
          emit(FaceFailure('Username sudah terdaftar'));
        }
      } catch (e, stackTrace) {
        debugPrint('error during login: $e');
        debugPrint('stackTrace: $stackTrace');
        emit(FaceFailure('Terjadi kesalahan saat sigup'));
      }
    });
  }
}
