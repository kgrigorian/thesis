part of 'media_library_bloc.dart';

abstract class MediaLibraryState extends Equatable {
  const MediaLibraryState();
  @override
  List<Object> get props => [];
}

class LoadingMediaState extends MediaLibraryState {}

class LoadedMediaState extends MediaLibraryState {
  const LoadedMediaState(this.mediaItems);
  final List<MediaItem> mediaItems;
  @override
  List<Object> get props => [mediaItems];
}
