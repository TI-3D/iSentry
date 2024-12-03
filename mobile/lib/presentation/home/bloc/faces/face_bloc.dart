import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/face_model.dart';
import 'package:isentry/presentation/home/bloc/faces/face_event.dart';
import 'package:isentry/presentation/home/bloc/faces/face_state.dart';
import 'package:http/http.dart' as http;
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
          final List<Face> faces = (data['data'] as List)
              .map((json) => Face.fromJson(json))
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
      emit(FaceLoading());
      try {
        final url = Uri.http(ipAddress, 'api/faces/unrecognized');
        final data = await NetworkService.get(url.toString());

        if (data.containsKey('data')) {
          final List<Face> faces = (data['data'] as List)
              .map((json) => Face.fromJson(json))
              .toList();
          emit(FaceLoaded(faces));
        } else {
          emit(FaceError("Invalid response structure: $data"));
        }
      } catch (e) {
        emit(FaceError("Failed to load unrecognized faces: $e"));
      }
    });

    on<AddFace>((event, emit) async {
      try {
        final url = Uri.http(ipAddress, 'api/faces');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(event.face.toJson()),
        );

        if (response.statusCode == 200) {
          add(LoadFaces());
        } else {
          emit(FaceError("Failed to add face: ${response.body}"));
        }
      } catch (e) {
        emit(FaceError("Failed to add face: $e"));
      }
    });

    on<UpdateFace>((event, emit) async {
      try {
        final url = Uri.http(ipAddress, 'api/faces/${event.face.id}');
        final response = await http.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(event.face.toJson()),
        );

        if (response.statusCode == 200) {
          add(LoadFaces());
        } else {
          emit(FaceError("Failed to update face: ${response.body}"));
        }
      } catch (e) {
        emit(FaceError("Failed to update face: $e"));
      }
    });

    on<DeleteFace>((event, emit) async {
      try {
        final url = Uri.http(ipAddress, 'api/faces/${event.id}');
        final response = await http.delete(url);

        if (response.statusCode == 200) {
          add(LoadFaces());
        } else {
          emit(FaceError("Failed to delete face: ${response.body}"));
        }
      } catch (e) {
        emit(FaceError("Failed to delete face: $e"));
      }
    });
  }
}
