import 'package:aqueduct/aqueduct.dart';
import 'package:music_service/music_service.dart';

import 'media_item.dart';

class Playlist extends ManagedObject<_Playlist> implements _Playlist {
}

class _Playlist {
  @primaryKey
  int id;

  String title;

  ManagedSet<MediaItem> mediaItems;

}