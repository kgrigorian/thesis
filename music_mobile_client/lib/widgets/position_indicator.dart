import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PositionIndicator extends StatelessWidget {
  PositionIndicator({
    @required this.mediaItem,
    @required this.state,
  });

  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);
  final MediaItem mediaItem;
  final PlaybackState state;

  @override
  Widget build(BuildContext context) {
    double seekPos;
    return StreamBuilder(
      stream: Rx.combineLatest2<double, double, double>(
          _dragPositionSubject.stream,
          Stream.periodic(Duration(milliseconds: 200)),
          (dragPosition, _) => dragPosition),
      builder: (context, snapshot) {
        double position = snapshot.data ?? state.currentPosition.toDouble();
        double duration = mediaItem?.duration?.toDouble();
        return Column(
          children: [
            if (duration != null)
              Slider(
                min: 0.0,
                max: duration,
                value: seekPos ?? max(0.0, min(position, duration)),
                onChanged: (value) {
                  _dragPositionSubject.add(value);
                },
                onChangeEnd: (value) {
                  AudioService.seekTo(value.toInt());
                  seekPos = value;
                  _dragPositionSubject.add(null);
                },
              ),
            Text("${(state.currentPosition / 1000).toStringAsFixed(3)}"),
          ],
        );
      },
    );
  }
}
