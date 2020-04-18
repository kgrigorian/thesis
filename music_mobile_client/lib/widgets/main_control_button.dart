import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_mobile_client/main.dart';

class MainControlButton extends StatelessWidget {
  final BasicPlaybackState basicState;
  MainControlButton(this.basicState);

  @override
  Widget build(BuildContext context) {
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
