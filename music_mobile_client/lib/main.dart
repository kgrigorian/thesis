import 'package:flutter/material.dart';

import 'package:audio_service/audio_service.dart';
import 'package:music_mobile_client/resources/mock_queue.dart';
import 'package:music_mobile_client/screens/media_player_screen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Service Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MediaPlayerScreen(queue),
    );
  }
}
