import 'package:aqueduct/aqueduct.dart';
import 'package:music_service/music_service.dart';

import 'album.dart';

class MediaItem extends ManagedObject<_MediaItem> implements _MediaItem {
}

class _MediaItem {
  @primaryKey
  int id;

  String uri;

  String title;

  @Relate(#mediaItems)
  String author;

  int duration;

  String artUri;

  @Relate(#mediaItems)
  Album album;

}