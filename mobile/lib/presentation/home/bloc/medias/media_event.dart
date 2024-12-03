import 'package:equatable/equatable.dart';
import 'package:isentry/data/models/media_item_model.dart';

abstract class MediaEvent extends Equatable {
  const MediaEvent();

  @override
  List<Object> get props => [];
}

class LoadMedia extends MediaEvent {
  @override
  List<Object> get props => [];
}

class AddMedia extends MediaEvent {
  final MediaItem mediaItem;

  const AddMedia(this.mediaItem);

  @override
  List<Object> get props => [mediaItem];
}

class UpdateMedia extends MediaEvent {
  final MediaItem mediaItem;

  const UpdateMedia(this.mediaItem);

  @override
  List<Object> get props => [mediaItem];
}

class DeleteMedia extends MediaEvent {
  final String id;

  const DeleteMedia(this.id);

  @override
  List<Object> get props => [id];
}