import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_mobile_client/widgets/play_controls_widget.dart';
import 'package:music_mobile_client/widgets/player_appbar_widget.dart';
import 'package:music_mobile_client/widgets/position_indicator_widget.dart';

class MediaPlayerScreen extends StatefulWidget {
  final List<MediaItem> mediaItems;
  MediaPlayerScreen(this.mediaItems);

  @override
  _MediaPlayerScreenState createState() => _MediaPlayerScreenState();
}

class _MediaPlayerScreenState extends State<MediaPlayerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blueColor,
      body: StreamBuilder<MediaItem>(
          stream: AudioService.currentMediaItemStream,
          builder: (context, mediaItemSnapshot) {
            if (mediaItemSnapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: blueColor,
                  strokeWidth: 8,
                ),
              );
            }

            return Stack(
              children: <Widget>[
                ..._background(mediaItemSnapshot.data.artUri),
                SafeArea(
                  minimum: const EdgeInsets.fromLTRB(12, 40, 12, 12),
                  child: Column(
                    children: <Widget>[
                      PlayerAppBar(mediaItemSnapshot.data),
                      Spacer(flex: 2),
                      ..._title(mediaItemSnapshot.data),
                      SizedBox(height: 16.0),
                      PositionIndicator(mediaItem: mediaItemSnapshot.data),
                      PlayControls(mediaItemSnapshot.data),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  List<Widget> _title(MediaItem mediaItem) {
    return [
      Text(
        mediaItem.title,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 32.0),
      ),
      SizedBox(
        height: 6.0,
      ),
      Text(
        mediaItem.artist,
        style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 18.0),
      )
    ];
  }

  List<Widget> _background(String image) {
    return [
      Container(
        decoration: BoxDecoration(
            image:
                DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
      ),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [blueColor.withOpacity(0.4), blueColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
      )
    ];
  }
}

var blueColor = Color(0xFF090e42);
var pinkColor = Color(0xFFff6b80);
