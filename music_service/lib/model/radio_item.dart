import 'package:aqueduct/aqueduct.dart';
import 'package:music_service/model/author.dart';
import 'package:music_service/music_service.dart';

import 'album.dart';

class RadioItem extends ManagedObject<_RadioItem> implements _RadioItem {
}

class _RadioItem {
  @primaryKey
  int id;

  String uri;

  String title;

  String artUri;

}