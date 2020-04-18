import 'package:audio_service/audio_service.dart';

class ScreenState {
  final List<MediaItem> queue;
  final PlaybackState playbackState;

  ScreenState(this.queue, this.playbackState);
}
