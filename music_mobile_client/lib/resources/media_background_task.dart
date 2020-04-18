import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_mobile_client/core/services/media_persistance_service.dart';

class MediaPlayerTask extends BackgroundAudioTask {
  List<MediaItem> mediaItemsQueue;
  int _queueIndex = -1;
  AudioPlayer _audioPlayer = AudioPlayer();
  MediaPersistanceService _mediaPersistanceService = MediaPersistanceService();
  Completer _completer = Completer();
  BasicPlaybackState _skipState;
  bool _playing;
  bool get hasNext => _queueIndex + 1 < mediaItemsQueue.length;
  bool get hasPrevious => _queueIndex > 0;
  MediaItem get mediaItem => mediaItemsQueue[_queueIndex];

  BasicPlaybackState _eventToBasicState(AudioPlaybackEvent event) {
    if (event.buffering) {
      return BasicPlaybackState.buffering;
    } else {
      switch (event.state) {
        case AudioPlaybackState.none:
          return BasicPlaybackState.none;
        case AudioPlaybackState.stopped:
          return BasicPlaybackState.stopped;
        case AudioPlaybackState.paused:
          return BasicPlaybackState.paused;
        case AudioPlaybackState.playing:
          return BasicPlaybackState.playing;
        case AudioPlaybackState.connecting:
          return _skipState ?? BasicPlaybackState.connecting;
        case AudioPlaybackState.completed:
          return BasicPlaybackState.stopped;
        default:
          throw Exception("Illegal state");
      }
    }
  }

  @override
  Future<void> onStart() async {
    mediaItemsQueue = await _mediaPersistanceService.getPersistedMediaList();
    var playerStateSubscription = _audioPlayer.playbackStateStream
        .where((state) => state == AudioPlaybackState.completed)
        .listen((state) {
      _handlePlaybackCompleted();
    });
    var eventSubscription = _audioPlayer.playbackEventStream.listen((event) {
      final state = _eventToBasicState(event);
      if (state != BasicPlaybackState.stopped) {
        _setState(
          state: state,
          position: event.position.inMilliseconds,
        );
      }
    });
    AudioServiceBackground.setQueue(mediaItemsQueue);
    await onSkipToNext();
    await _completer.future;
    playerStateSubscription.cancel();
    eventSubscription.cancel();
  }

  void _handlePlaybackCompleted() {
    if (hasNext) {
      onSkipToNext();
    } else {
      onStop();
    }
  }

  void playPause() {
    if (AudioServiceBackground.state.basicState == BasicPlaybackState.playing)
      onPause();
    else
      onPlay();
  }

  @override
  Future<void> onSkipToNext() => _skip(1);

  @override
  Future<void> onSkipToPrevious() => _skip(-1);

  Future<void> _skip(int offset) async {
    if (mediaItemsQueue == null) return;
    final newPos = _queueIndex + offset;
    if (!(newPos >= 0 && newPos < mediaItemsQueue.length)) return;
    if (_playing == null) {
      _playing = true;
    } else if (_playing) {
      await _audioPlayer.stop();
    }

    _queueIndex = newPos;
    AudioServiceBackground.setMediaItem(mediaItem);
    _skipState = offset > 0
        ? BasicPlaybackState.skippingToNext
        : BasicPlaybackState.skippingToPrevious;
    await _audioPlayer.setUrl(mediaItem.id);
    _skipState = null;

    if (_playing) {
      onPlay();
    } else {
      _setState(state: BasicPlaybackState.paused);
    }
  }

  @override
  void onPlay() {
    if (_skipState == null) {
      _playing = true;
      _audioPlayer.play();
    }
  }

  @override
  void onPause() {
    if (_skipState == null) {
      _playing = false;
      _audioPlayer.pause();
    }
  }

  @override
  void onSeekTo(int position) {
    _audioPlayer.seek(Duration(milliseconds: position));
  }

  @override
  void onClick(MediaButton button) {
    playPause();
  }

  @override
  void onStop() {
    _audioPlayer.stop();
    _setState(state: BasicPlaybackState.stopped);
    _completer.complete();
  }

  void _setState({@required BasicPlaybackState state, int position}) {
    if (position == null) {
      position = _audioPlayer.playbackEvent.position.inMilliseconds;
    }
    AudioServiceBackground.setState(
      controls: getControls(state),
      systemActions: [MediaAction.seekTo],
      basicState: state,
      position: position,
    );
  }

  List<MediaControl> getControls(BasicPlaybackState state) {
    if (_playing) {
      return [
        AndroidControls.skipToPreviousControl,
        AndroidControls.pauseControl,
        AndroidControls.stopControl,
        AndroidControls.skipToNextControl
      ];
    } else {
      return [
        AndroidControls.skipToPreviousControl,
        AndroidControls.playControl,
        AndroidControls.stopControl,
        AndroidControls.skipToNextControl
      ];
    }
  }
}

class AndroidControls {
  static const MediaControl playControl = MediaControl(
    androidIcon: 'drawable/ic_action_play_arrow',
    label: 'Play',
    action: MediaAction.play,
  );
  static const MediaControl pauseControl = MediaControl(
    androidIcon: 'drawable/ic_action_pause',
    label: 'Pause',
    action: MediaAction.pause,
  );
  static const MediaControl skipToNextControl = MediaControl(
    androidIcon: 'drawable/ic_action_skip_next',
    label: 'Next',
    action: MediaAction.skipToNext,
  );
  static const MediaControl skipToPreviousControl = MediaControl(
    androidIcon: 'drawable/ic_action_skip_previous',
    label: 'Previous',
    action: MediaAction.skipToPrevious,
  );
  static const MediaControl stopControl = MediaControl(
    androidIcon: 'drawable/ic_action_stop',
    label: 'Stop',
    action: MediaAction.stop,
  );
}
