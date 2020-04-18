part of 'media_library_bloc.dart';

abstract class MediaLibraryEvent extends Equatable {
  const MediaLibraryEvent();
}

class GetMediaEvent extends MediaLibraryEvent {
  @override
  List<Object> get props => null;
}
