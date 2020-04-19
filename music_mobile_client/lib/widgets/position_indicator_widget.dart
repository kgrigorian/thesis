import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_mobile_client/main.dart';
import 'package:rxdart/rxdart.dart';

class PositionIndicator extends StatefulWidget {
  PositionIndicator({@required mediaItem})
      : this.duration = mediaItem.duration.toDouble();
  final double duration;

  @override
  _PositionIndicatorState createState() => _PositionIndicatorState();
}

class _PositionIndicatorState extends State<PositionIndicator> {
  final BehaviorSubject<double> _dragPositionSubject =
      BehaviorSubject.seeded(null);
  double seekPosition;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Rx.combineLatest3<double, PlaybackState, double, List<double>>(
          _dragPositionSubject.stream,
          AudioService.playbackStateStream,
          Stream.periodic(Duration(milliseconds: 1000)),
          (dragPosition, playbackState, _) =>
              [dragPosition, playbackState.currentPosition.toDouble()]),
      builder: (BuildContext context, AsyncSnapshot<List<double>> snapshot) {
        double position = snapshot.data[0] ?? snapshot.data[1];
        return Container(
          child: Column(
            children: [
              if (widget.duration != null)
                Slider(
                  min: 0.0,
                  max: widget.duration,
                  value:
                      seekPosition ?? max(0.0, min(position, widget.duration)),
                  onChanged: (value) {
                    _dragPositionSubject.add(value);
                  },
                  onChangeEnd: (value) {
                    AudioService.seekTo(value.toInt());
                    seekPosition = value;
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
