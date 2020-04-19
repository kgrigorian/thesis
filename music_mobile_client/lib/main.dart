import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_mobile_client/core/bloc/media_library_bloc.dart';
import 'package:music_mobile_client/resources/media_background_task.dart';
import 'package:music_mobile_client/screens/library_screen.dart';

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
        child: BlocProvider(
          create: (BuildContext context) =>
              MediaLibraryBloc()..add(GetMediaEvent()),
          child: LibraryScreen(),
        ),
      ),
    );
  }
}

void audioPlayerTaskEntrypoint() async {
  AudioServiceBackground.run(
    () => MediaPlayerTask(),
  );
}

var blueColor = Color(0xFF090e42);
var pinkColor = Color(0xFFff6b80);
