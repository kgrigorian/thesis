import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:music_mobile_client/extensions/media_item_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MediaPersistanceService {

  Future<bool> persistMediaList(List<MediaItem> mediaItems) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('ms', jsonEncode(mediaToJson(mediaItems)));
  }

  Future<List<MediaItem>> getPersistedMediaList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var string = prefs.getString('ms');
    return List<MediaItem>.from(
        (jsonDecode(string) as Iterable).map((m) => mediaFromJson(m)));
  }
}




