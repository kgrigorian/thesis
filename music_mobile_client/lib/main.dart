import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

import 'package:music_mobile_client/resources/mock_queue.dart';
import 'package:music_mobile_client/screens/media_player_screen.dart';

import 'env.dart';

void main() => runApp(new MyApp());

final String api = DebugEnvironment().api;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Player Client',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: AudioServiceWidget(
        child: MediaPlayerScreen(queue),
      ),
    );
  }
}
