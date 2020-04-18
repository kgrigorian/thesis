import 'package:aqueduct/aqueduct.dart';
import 'package:music_service/music_service.dart';

import 'author.dart';
import 'media_item.dart';

class Album extends ManagedObject<_Album> implements _Album {
}

class _Album {
  @primaryKey
  int id;

  String title;

  @Relate(#albums)
  Author author;

  String year;

  ManagedSet<MediaItem> mediaItems;

}