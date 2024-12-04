import 'package:equatable/equatable.dart';
import 'package:isentry/data/models/media_item_model.dart';

abstract class MediaState extends Equatable {
  const MediaState();

  @override
  List<Object> get props => [];
}

class MediaInitial extends MediaState {}

class MediaLoading extends MediaState {}

class MediaLoaded extends MediaState {
  final List<MediaItem> mediaItems;

  const MediaLoaded(this.mediaItems);

  @override
  List<Object> get props => [mediaItems];
}

class MediaError extends MediaState {
  final String message;

  const MediaError(this.message);

  @override
  List<Object> get props => [message];
}