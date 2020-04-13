import 'package:aqueduct/aqueduct.dart';
import 'package:music_service/music_service.dart';

import 'media_item.dart';

class Author extends ManagedObject<_Author> implements _Author {
}

class _Author {
  @primaryKey
  int id;

  String name;

  ManagedSet<MediaItem> mediaItems;

  ManagedSet<MediaItem> albums;

}