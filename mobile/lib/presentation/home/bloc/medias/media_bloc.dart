import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isentry/core/configs/ip_address.dart';
import 'package:isentry/data/models/media_item_model.dart';
import 'package:isentry/presentation/home/bloc/medias/media_event.dart';
import 'package:isentry/presentation/home/bloc/medias/media_state.dart';
import 'package:isentry/services/network_service.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  MediaBloc() : super(MediaInitial()) {
    on<LoadMedia>((event, emit) async {
      emit(MediaLoading());
      try {
        final url = Uri.http(ipAddress, 'api/medias/gallery');
        final response = await NetworkService.get(url.toString());
        if (response['success'] == true && response['data'] is List) {
          const String baseUrl = "http://$ipAddress";
          List<MediaItem> mediaItems = (response['data'] as List).map((item) {
            final originalItem = MediaItem.fromJson(item);
            return MediaItem(
              id: originalItem.id,
              type: originalItem.type,
              captureMethod: originalItem.captureMethod,
              path:
                  "$baseUrl${originalItem.path}", // Tambahkan base URL ke path
              createdAt: originalItem.createdAt,
              updatedAt: originalItem.updatedAt,
            );
          }).toList();
          emit(MediaLoaded(mediaItems));
        } else {
          emit(MediaError(response['message'] ?? "Failed to load media."));
        }
      } catch (e) {
        print("Error occurred: $e");
        emit(MediaError("Failed to load media: $e"));
      }
    });
  }
}
