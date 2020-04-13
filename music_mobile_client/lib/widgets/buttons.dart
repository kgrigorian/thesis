import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

RaisedButton startButton(String label, VoidCallback onPressed) => RaisedButton(
      child: Text(label),
      onPressed: onPressed,
    );

IconButton playButton() => IconButton(
      icon: Icon(Icons.play_arrow),
      iconSize: 64.0,
      onPressed: AudioService.play,
    );

IconButton pauseButton() => IconButton(
      icon: Icon(Icons.pause),
      iconSize: 64.0,
      onPressed: AudioService.pause,
    );

IconButton stopButton() => IconButton(
      icon: Icon(Icons.stop),
      iconSize: 64.0,
      onPressed: AudioService.stop,
    );
