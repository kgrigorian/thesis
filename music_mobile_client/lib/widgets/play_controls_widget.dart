import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_mobile_client/main.dart';

class PlayControls extends StatelessWidget {
  PlayControls(this.mediaItem);
  final MediaItem mediaItem;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AudioService.queueStream,
      builder: (context, AsyncSnapshot<List<MediaItem>> queueSnapshot) {
        final queue = queueSnapshot.data;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.fast_rewind,
                    color: Colors.white54,
                    size: 42.0,
                  ),
                  onPressed: mediaItem == queue.last
                      ? null
                      : AudioService.skipToPrevious),
              _MainControlButton(),
              IconButton(
                icon: Icon(
                  Icons.fast_forward,
                  color: Colors.white54,
                  size: 42.0,
                ),
                onPressed:
                    mediaItem == queue.last ? null : AudioService.skipToNext,
              )
            ],
          ),
        );
      },
    );
  }
}

class _MainControlButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AudioService.playbackStateStream,
      builder: (context, state) {
        final basicState = state?.data ?? BasicPlaybackState.none;
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                color: pinkColor, borderRadius: BorderRadius.circular(50.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                _getIconFromState(basicState),
                size: 58.0,
                color: Colors.white,
              ),
            ),
          ),
          onTap: () {
            if (basicState == BasicPlaybackState.playing) {
              AudioService.pause();
            }
            if (basicState == BasicPlaybackState.paused) {
              AudioService.play();
            }
            if (basicState == BasicPlaybackState.playing) {
              AudioService.pause();
            }
          },
        );
      },
    );
  }

  IconData _getIconFromState(basicState) {
    if (basicState == BasicPlaybackState.playing) {
      return Icons.pause;
    }
    if (basicState == BasicPlaybackState.paused) {
      return Icons.play_arrow;
    }
    return Icons.stop;
  }
}
