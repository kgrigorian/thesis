import 'dart:async';
import 'dart:io';

import 'package:aqueduct/aqueduct.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:http_server/http_server.dart';
import 'package:mime/mime.dart';

class UploadController extends ResourceController {
  UploadController() {
    acceptedContentTypes = [ContentType("multipart", "form-data")];
  }

  @Operation.post()
  Future<Response> postForm() async {
    final boundary = request.raw.headers.contentType.parameters["boundary"];
    final transformer = MimeMultipartTransformer(boundary);
    final bodyBytes = await request.body.decode<List<int>>();
    final bodyStream = Stream.fromIterable([bodyBytes]);
    final parts = await transformer.bind(bodyStream).toList();

    for (var part in parts) {
      final headers = part.headers;

      final HttpMultipartFormData multipart = HttpMultipartFormData.parse(part);
      final content = multipart.cast<List<int>>();
      final filePath =
          "music/" + DateTime.now().millisecondsSinceEpoch.toString() + ".mp3";

      final IOSink sink = File(filePath).openWrite();
      await content.forEach((item) async => sink.add(item));
      await sink.flush();
      await sink.close();
      final tp = TagProcessor();
      await tp
          .getTagsFromByteArray(File(filePath).readAsBytes())
          .then((l) => l.forEach(print));
    }
    return Response.ok({});
  }
}
