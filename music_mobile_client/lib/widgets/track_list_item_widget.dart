import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:music_mobile_client/core/services/media_persistance_service.dart';
import 'package:music_mobile_client/main.dart';
import 'package:music_mobile_client/screens/media_player_screen.dart';

class TrackListItem extends StatelessWidget {
  TrackListItem(this.mediaItem);
  final MediaItem mediaItem;
  final MediaPersistanceService mediaPersister = MediaPersistanceService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        bool saved = await mediaPersister.persistMediaList([mediaItem]);
        bool running = AudioService.running;
        if (running) {
          await AudioService.stop();
        }
        if (saved)
          await AudioService.start(
            backgroundTaskEntrypoint: audioPlayerTaskEntrypoint,
            androidNotificationChannelName: 'Audio Service Demo',
            notificationColor: 0xFF2196f3,
            androidNotificationIcon: 'mipmap/ic_launcher',
            enableQueue: true,
          );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MediaPlayerScreen(),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 26.0),
        child: Row(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 80.0,
                  width: 80.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      mediaItem.artUri,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                    height: 80.0,
                    width: 80.0,
                    child: Icon(
                      Icons.play_circle_filled,
                      color: Colors.white.withOpacity(0.7),
                      size: 42.0,
                    ))
              ],
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  mediaItem.title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0),
                ),
                SizedBox(height: 8.0),
                Text(
                  mediaItem.artist,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5), fontSize: 18.0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
