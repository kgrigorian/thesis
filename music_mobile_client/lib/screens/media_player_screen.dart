import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_mobile_client/resources/media_playing_state.dart';
import 'package:music_mobile_client/widgets/main_control_button.dart';
import 'package:rxdart/rxdart.dart';
import 'package:music_mobile_client/widgets/position_indicator.dart';

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
            final queue = screenState?.data?.queue;
            final state = screenState?.data?.playbackState;
            final basicState = state?.basicState ?? BasicPlaybackState.none;
            return Stack(
              children: <Widget>[
                ..._background(mediaItemSnapshot.data.artUri),
                SafeArea(
                  minimum: const EdgeInsets.fromLTRB(12, 40, 12, 12),
                  child: Column(
                    children: <Widget>[
                      _playerBar(mediaItemSnapshot.data),
                      Spacer(flex: 2),
                      ..._title(mediaItemSnapshot.data),
                      SizedBox(height: 16.0),
                      PositionIndicator(
                          mediaItem: mediaItemSnapshot.data, state: state),
                      _playControls(basicState, mediaItemSnapshot.data, queue),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  Stream<ScreenState> get _screenStateStream =>
      Rx.combineLatest2<List<MediaItem>, PlaybackState, ScreenState>(
        AudioService.queueStream,
        AudioService.playbackStateStream,
        (queue, playbackState) => ScreenState(queue, playbackState),
      );

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

  _playControls(basicState, mediaItem, queue) {
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
              onPressed:
                  mediaItem == queue.last ? null : AudioService.skipToPrevious),
          MainControlButton(basicState),
          IconButton(
            icon: Icon(
              Icons.fast_forward,
              color: Colors.white54,
              size: 42.0,
            ),
            onPressed: mediaItem == queue.last ? null : AudioService.skipToNext,
          )
        ],
      ),
    );
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

  _playerBar(MediaItem mediaItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(50.0)),
          child: Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
          ),
        ),
        Column(
          children: <Widget>[
            Text(
              'PLAYLIST / ALBUM',
              style: TextStyle(color: Colors.white.withOpacity(0.6)),
            ),
            Text(mediaItem.album, style: TextStyle(color: Colors.white)),
          ],
        ),
        Icon(
          Icons.playlist_add,
          color: Colors.white,
        )
      ],
    );
  }

  _controls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(
          Icons.bookmark_border,
          color: pinkColor,
        ),
        Icon(
          Icons.shuffle,
          color: pinkColor,
        ),
        Icon(
          Icons.repeat,
          color: pinkColor,
        ),
      ],
    );
  }
}

var blueColor = Color(0xFF090e42);
var pinkColor = Color(0xFFff6b80);
