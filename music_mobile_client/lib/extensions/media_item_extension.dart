import 'package:audio_service/audio_service.dart';
import 'package:music_mobile_client/main.dart';

extension on MediaItem {
  static MediaItem fromJson(Map<String, dynamic> jsonData) {
    return MediaItem(
        album: jsonData['album'],
        artist: jsonData['artist'],
        artUri: jsonData['artUri'],
        id: jsonData['id'],
        title: jsonData['title']);
  }
}

MediaItem mediaFromJson(Map<String, dynamic> jsonData) => MediaItem(
    album: jsonData['artUri'].toString().contains('http')
        ? jsonData['album']
        : jsonData['album']['title'],
    artist: jsonData['artUri'].toString().contains('http')
        ? jsonData['artist']
        : jsonData['author']['name'],
    artUri: jsonData['artUri'].toString().contains('http')
        ? jsonData['artUri']
        : '$api/${jsonData['artUri']}',
    duration: jsonData['duration'],
    id: jsonData['uri'].toString().contains('http')
        ? jsonData['uri']
        : '$api/${jsonData['uri']}',
    title: jsonData['title']);

List<Map<String, dynamic>> mediaToJson(List<MediaItem> mediaItems) => [
      for (var mediaItem in mediaItems)
        {
          'uri': mediaItem.id,
          'artist': mediaItem.artist,
          'artUri': mediaItem.artUri,
          'duration': mediaItem.duration,
          'title': mediaItem.title,
          'album': mediaItem.album
        }
    ];
