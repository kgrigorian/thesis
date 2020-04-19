import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';

class PlayerAppBar extends StatelessWidget {
  const PlayerAppBar(this.mediaItem);
  final MediaItem mediaItem;
  @override
  Widget build(BuildContext context) {
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
}
