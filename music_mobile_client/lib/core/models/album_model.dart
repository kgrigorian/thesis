import 'package:audio_service/audio_service.dart';
import 'package:music_mobile_client/extensions/media_item_extension.dart';

class Album {
  int id;
  String title;
  String author;
  String year;
  List<MediaItem> mediaItems;

  Album.fromJson(Map<String, dynamic> json) {
    this.id = json['id'];
    this.title = json['title'];
    this.author = json['author']['name'];
    this.year = json['year'];
    this.mediaItems = List<MediaItem>.from(
        json['mediaItems'].map((jsonItem) => mediaFromJson(jsonItem)));
  }
}
