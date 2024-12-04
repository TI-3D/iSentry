import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/detection_detail_model.dart';
import 'package:isentry/data/models/detection_model.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_event.dart';
import 'package:isentry/presentation/home/bloc/detection_log/detection_state.dart';
import 'package:isentry/services/network_service.dart';

class DetectionBloc extends Bloc<DetectionEvent, DetectionState> {
  DetectionBloc() : super(DetectionInitial()) {
    on<GetDetectionById>((event, emit) async {
      print("Fetching user with ID: ${event.id}");
      emit(DetectionLoading());

      try {
        final url = Uri.http(ipAddress, 'api/detection-logs/${event.id}');
        final response = await NetworkService.get(url.toString());

        if (response['success']) {
          DetectionModel detection = DetectionModel.fromJson(response['data']);
          emit(DetectionLoaded(detection));
        } else {
          emit(DetectionFailure(response['message']));
        }
      } catch (e) {
        emit(DetectionFailure("Failed to fetch user: $e"));
      }
    });

    on<GetAllDetection>((event, emit) async {
      emit(DetectionLoading());

      try {
        final url = Uri.http(ipAddress, 'api/detection-logs');
        final response = await NetworkService.get(url.toString());

        if (response['success']) {
          final allDetections = (response['data'] as List)
              .map((detection) => DetectionModel.fromJson(detection))
              .toList();
          emit(AllDetectionLoaded(allDetections));
        } else {
          emit(DetectionFailure(response['message'] ?? 'Failed to load users'));
        }
      } catch (e) {
        emit(DetectionFailure('Failed to fetch users: $e'));
      }
    });

    on<DeleteDetection>((event, emit) async {
      emit(DetectionLoading());

      try {
        final url = Uri.http(ipAddress, 'api/detection-logs/${event.id}');
        final response = await NetworkService.delete(url.toString());

        if (response['success']) {
          emit(DetectionDeleted());
          add(GetAllDetection());
        } else {
          emit(DetectionFailure(response['message']));
        }
      } catch (e) {
        emit(DetectionFailure("Failed to fetch user: $e"));
      }
    });

    on<DetectionSubmitted>((event, emit) async {
      emit(DetectionLoading());
      try {
        var url = Uri.http(ipAddress, 'api/detection-logs');
        var response = await NetworkService.post(url.toString(), body: {
          'face': event.face,
        });

        if (response['success']) {
          emit(DetectionSuccess());
        } else {
          emit(DetectionFailure('Username sudah terdaftar'));
        }
      } catch (e, stackTrace) {
        debugPrint('error during login: $e');
        debugPrint('stackTrace: $stackTrace');
        emit(DetectionFailure('Terjadi kesalahan saat sigup'));
      }
    });

    on<DetectionDetail>((event, emit) async {
      emit(DetectionLoading());
      try {
        final url = Uri.http(ipAddress, 'api/detection-logs/detail');
        final response = await NetworkService.get(url.toString());

        if (response['success']) {
          final jsonResponse = response;

          List<DetectionDetailModel> recognizedDetails =
              (jsonResponse['recognized'] as List)
                  .map((item) => DetectionDetailModel.fromJson(item, true))
                  .toList();

          List<DetectionDetailModel> unrecognizedDetails =
              (jsonResponse['unrecognized'] as List)
                  .map((item) => DetectionDetailModel.fromJson(item, false))
                  .toList();

          emit(DetailDetectionLoaded(recognizedDetails, unrecognizedDetails));
        } else {
          emit(DetectionFailure(response['message'] ?? 'Failed to load users'));
        }
      } catch (e) {
        emit(DetectionFailure('Failed to fetch users: $e'));
      }
    });
  }
}
