import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_mobile_client/main.dart';
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
          Stream.periodic(Duration(milliseconds: 1000)),
          (dragPosition, _) => dragPosition),
      builder: (context, snapshot) {
        double position = snapshot.data ?? state.currentPosition.toDouble();
        double duration = mediaItem.duration.toDouble();
        return Container(
          child: Column(
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
                  activeColor: pinkColor,
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '2:10',
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                    Text('-03:56',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)))
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
