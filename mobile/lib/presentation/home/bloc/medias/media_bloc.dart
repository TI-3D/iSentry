import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/media_item_model.dart';
import 'package:isentry/presentation/home/bloc/medias/media_event.dart';
import 'package:isentry/presentation/home/bloc/medias/media_state.dart';
import 'package:isentry/services/network_service.dart';
import 'package:http/http.dart' as http;

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  MediaBloc() : super(MediaInitial()) {
    on<LoadMedia>((event, emit) async {
      emit(MediaLoading());
      try {
        final url = Uri.http(ipAddress, 'api/medias');
        final response = await NetworkService.get(url.toString()); // ini sudah berupa Map
        if (response['success']) {
          List<MediaItem> mediaItems = (response['data'] as List)
              .map((item) => MediaItem.fromJson(item))
              .toList();
          emit(MediaLoaded(mediaItems));
        } else {
          emit(MediaError("Failed to load media: ${response['message']}"));
        }
      } catch (e) {
        print("Error occurred: $e");
        emit(MediaError("Failed to load media: $e"));
    }
  });

    on<AddMedia>((event, emit) async {
      // Simpan data media baru ke API
      try {
        final url = Uri.http(ipAddress, 'api/medias');
        final response = await http.post(url, body: jsonEncode(event.mediaItem.toJson()));

        if (response.statusCode == 200) {
          // Setelah berhasil menambah data, lakukan pemanggilan ulang ke API untuk mendapatkan data terbaru
          add(LoadMedia());
        } else {
          emit(const MediaError("Failed to add media"));
        }
      } catch (e) {
        emit(MediaError("Failed to add media: $e"));
      }
    });

    on<UpdateMedia>((event, emit) async {
      // Update data media di API
      try {
        final url = Uri.http(ipAddress, 'api/medias/${event.mediaItem.id}');
        final response = await http.put(url, body: jsonEncode(event.mediaItem.toJson()));

        if (response.statusCode == 200) {
          // Setelah berhasil mengupdate, lakukan pemanggilan ulang ke API
          add(LoadMedia());
        } else {
          emit(const MediaError("Failed to update media"));
        }
      } catch (e) {
        emit(MediaError("Failed to update media: $e"));
      }
    });

    on<DeleteMedia>((event, emit) async {
      // Hapus media dari API
      try {
        final url = Uri.http(ipAddress, 'api/medias/${event.id}');
        final response = await http.delete(url);

        if (response.statusCode == 200) {
          // Setelah berhasil menghapus, lakukan pemanggilan ulang ke API
          add(LoadMedia());
        } else {
          emit(const MediaError("Failed to delete media"));
        }
      } catch (e) {
        emit(MediaError("Failed to delete media: $e"));
      }
    });
  }
}
