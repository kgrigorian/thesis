import 'dart:io';

import 'package:dart_tags/dart_tags.dart';

class MediaMetaDataService {

  TagProcessor tagProcessor = TagProcessor();

  Future<List<Tag>> getTagsFromFile(String filePath) async {
    final fileAsBytesArray = File(filePath).readAsBytes();
    return await tagProcessor.getTagsFromByteArray(fileAsBytesArray);

  }
}