import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_mobile_client/resources/media_background_task.dart';
import 'package:music_mobile_client/resources/media_playing_state.dart';
import 'package:rxdart/rxdart.dart';
import 'package:music_mobile_client/widgets/buttons.dart';
import 'package:music_mobile_client/widgets/position_indicator.dart';

class MediaPlayerScreen extends StatefulWidget {
  final List<MediaItem> queue;
  MediaPlayerScreen(this.queue);

  @override
  _MediaPlayerScreenState createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  @override
  void initState() {
    AudioService.start(
      backgroundTaskEntrypoint: () => AudioServiceBackground.run(
        () => MediaPlayerTask(widget.queue),
      ),
      notificationColor: 0xFF2196f3,
      enableQueue: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Service Demo'),
      ),
      body: AudioServiceWidget(
        child: Center(
          child: StreamBuilder<ScreenState>(
            stream: _screenStateStream,
            builder: (context, snapshot) {
              final screenState = snapshot.data;
              final queue = screenState?.queue;
              final mediaItem = screenState?.mediaItem;
              final state = screenState?.playbackState;
              final basicState = state?.basicState ?? BasicPlaybackState.none;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (queue != null && queue.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.skip_previous),
                          iconSize: 64.0,
                          onPressed: mediaItem == queue.first
                              ? null
                              : AudioService.skipToPrevious,
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_next),
                          iconSize: 64.0,
                          onPressed: mediaItem == queue.last
                              ? null
                              : AudioService.skipToNext,
                        ),
                      ],
                    ),
                  if (mediaItem?.title != null) Text(mediaItem.title),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (basicState == BasicPlaybackState.playing)
                        pauseButton()
                      else if (basicState == BasicPlaybackState.paused)
                        playButton()
                      else if (basicState == BasicPlaybackState.buffering ||
                          basicState == BasicPlaybackState.skippingToNext ||
                          basicState == BasicPlaybackState.skippingToPrevious)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 64.0,
                            height: 64.0,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      stopButton(),
                    ],
                  ),
                  if (basicState != BasicPlaybackState.none &&
                      basicState != BasicPlaybackState.stopped) ...[
                    PositionIndicator(mediaItem: mediaItem, state: state),
                    Text("State: " +
                        "$basicState".replaceAll(RegExp(r'^.*\.'), '')),
                  ]
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Stream<ScreenState> get _screenStateStream =>
      Rx.combineLatest3<List<MediaItem>, MediaItem, PlaybackState, ScreenState>(
        AudioService.queueStream,
        AudioService.currentMediaItemStream,
        AudioService.playbackStateStream,
        (queue, mediaItem, playbackState) =>
            ScreenState(queue, mediaItem, playbackState),
      );
}
