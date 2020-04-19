import 'package:aqueduct/aqueduct.dart';
import 'package:music_service/model/author.dart';
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
  Author author;

  int duration;

  @Column(defaultValue: 'false')
  bool favourite;

  String artUri;

  @Relate(#mediaItems)
  Album album;

}