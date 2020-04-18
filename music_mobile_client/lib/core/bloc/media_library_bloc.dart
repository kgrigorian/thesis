import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:music_mobile_client/core/services/media_library_service.dart';

part 'media_library_event.dart';
part 'media_library_state.dart';

class MediaLibraryBloc extends Bloc<MediaLibraryEvent, MediaLibraryState> {
  final mediaService = MediaLibraryService();
  @override
  MediaLibraryState get initialState => LoadingMediaState();

  @override
  Stream<MediaLibraryState> mapEventToState(
    MediaLibraryEvent event,
  ) async* {
    if (event is GetMediaEvent) {
      var mediaItems = await mediaService.getAllMediaItems();
      yield LoadedMediaState(mediaItems);
    }
  }
}
