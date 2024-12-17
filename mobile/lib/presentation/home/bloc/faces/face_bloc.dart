import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/face_model.dart';
import 'package:isentry/presentation/home/bloc/faces/face_event.dart';
import 'package:isentry/presentation/home/bloc/faces/face_state.dart';
import 'package:isentry/services/network_service.dart';

class FaceBloc extends Bloc<FaceEvent, FaceState> {
  FaceBloc() : super(FaceInitial()) {
    on<LoadFaces>((event, emit) async {
      emit(FaceLoading());
      try {
        final url = Uri.http(ipAddress, 'api/faces');
        print('Requesting API at URL: $url');
        final data = await NetworkService.get(url.toString());
        print(data);
        print(data['data']);

        if (data.containsKey('data')) {
          final List<FaceModel> faces = (data['data'] as List)
              .map((json) => FaceModel.fromJson(json))
              .toList();
          print('Mapped Faces: $faces');
          emit(FaceLoaded(faces));
        } else {
          print('Invalid response structure: $data');
          emit(FaceError("Invalid response structure: $data"));
        }
      } catch (e) {
        print('Exception Caught: $e');
        emit(FaceError("Failed to load faces: $e"));
      }
    });

    on<LoadUnrecognizedFaces>((event, emit) async {
      emit(FaceReloading());
      try {
        final url = Uri.http(ipAddress, 'api/faces/unrecognized');
        final data = await NetworkService.get(url.toString());
        print("Received unrecognized faces: $data");

        if (data.containsKey('data')) {
          final List<FaceModel> faces = (data['data'] as List)
              .map((json) => FaceModel.fromJson(json))
              .toList();
          print('Mapped Faces: $faces');
          emit(FaceLoaded(faces));
        } else {
          emit(FaceError("Invalid response structure: $data"));
        }
      } catch (e) {
        emit(FaceError("Failed to load unrecognized faces: $e"));
        print("Error: $e");
      }
    });

    on<DeleteFace>((event, emit) async {
      try {
        final url = Uri.http(ipAddress, 'api/faces/${event.id}');
        final response = await NetworkService.delete(url.toString());

        if (response['success']) {
          print('Face deleted successfully');
          emit(FaceDeleted());
          add(LoadUnrecognizedFaces()); // Memuat ulang data unrecognized
        } else {
          print('Failed to delete face: ${response['body']}');
          emit(FaceError("Failed to delete face: ${response['body']}"));
        }
      } catch (e) {
        print('Exception Caught: $e');
        emit(FaceError("Failed to delete face: $e"));
      }
    });
  }
}
