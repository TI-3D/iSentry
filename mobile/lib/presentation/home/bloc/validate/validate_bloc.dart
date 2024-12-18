import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/presentation/home/bloc/validate/validate_event.dart';
import 'package:isentry/presentation/home/bloc/validate/validate_state.dart';
import 'package:isentry/services/network_service.dart';

class FaceValidateBloc extends Bloc<FaceValidationEvent, FaceValidationState> {
  FaceValidateBloc() : super(FaceValidationInitial()) {
    on<ValidateFaceEvent>((event, emit) async {
      emit(FaceValidationLoading());

      try {
        final url = Uri.http(ipAI, 'validate-face');
        final response =
            await NetworkService.postMultipart(url.toString(), files: {
          'image': File(event.faceFile.path),
        });
        print("response: $response");

        if (response['success']) {
          emit(FaceValidationSuccess(faceId: response['message']));
        } else {
          emit(FaceValidationFailure(response['message']));
        }
      } catch (e) {
        emit(FaceValidationFailure("Failed to fetch user: $e"));
      }
    });
  }
}
