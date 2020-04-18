import 'dart:convert';
import 'package:audio_service/audio_service.dart';
import 'package:http/http.dart' as http;
import 'package:music_mobile_client/extensions/media_item_extension.dart';

import 'package:music_mobile_client/main.dart';

class MediaLibraryService {
  final http.Client client = http.Client();
  final _api = api;

  Future<List<MediaItem>> getAllMediaItems() async {
    var response = await client.get('$_api/all');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return List<MediaItem>.from(
        jsonResponse.map(
          (i) => mediaFromJson(i),
        ),
      );
    } else {
      throw Exception([response.statusCode, response.reasonPhrase]);
    }
  }
}
