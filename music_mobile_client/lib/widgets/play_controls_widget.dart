import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_mobile_client/widgets/main_control_button_widget.dart';

class PlayControls extends StatelessWidget {
  PlayControls(this.mediaItem);
  final MediaItem mediaItem;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AudioService.queueStream,
      builder: (context, AsyncSnapshot<List<MediaItem>> queueSnapshot) {
        final queue = queueSnapshot.data;
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
                  onPressed: mediaItem == queue.last
                      ? null
                      : AudioService.skipToPrevious),
              MainControlButton(),
              IconButton(
                icon: Icon(
                  Icons.fast_forward,
                  color: Colors.white54,
                  size: 42.0,
                ),
                onPressed:
                    mediaItem == queue.last ? null : AudioService.skipToNext,
              )
            ],
          ),
        );
      },
    );
  }
}
