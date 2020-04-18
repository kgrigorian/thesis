import 'dart:convert';
import 'package:dart_tags/dart_tags.dart';
import 'package:image/image.dart';
import 'dart:io';


class FileSystemService {

  Future<String> saveMediaFile(Stream<List<int>> bytesStream) async {
    final filePath =
        "music/" + DateTime.now().millisecondsSinceEpoch.toString() + ".mp3";

    final IOSink sink = File(filePath).openWrite();
    await bytesStream.forEach(sink.add);
    await sink.flush();
    await sink.close();
    return filePath;
  }

  Future<String> saveMediaImage(AttachedPicture pic) async {
    final filePath =
        "images/" + DateTime.now().millisecondsSinceEpoch.toString() + ".png";

    final image = decodeImage(pic.imageData);
    await File(filePath).writeAsBytes(encodePng(image));
    return filePath;
  }
}