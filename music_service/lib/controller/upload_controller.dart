import 'dart:async';
import 'dart:io';

import 'package:aqueduct/aqueduct.dart';
import 'package:dart_tags/dart_tags.dart';
import 'package:http_server/http_server.dart';
import 'package:mime/mime.dart';
import 'package:music_service/model/album.dart';
import 'package:music_service/model/author.dart';
import 'package:music_service/model/media_item.dart';
import 'package:music_service/service/file_system_service.dart';
import 'package:music_service/service/meta_data_service.dart';

class UploadController extends ResourceController {

  UploadController(this.context) {
    RequestBody.maxSize = 1024 * 1024 * 100; // larger max size to allow big files
    acceptedContentTypes = [ContentType("multipart", "form-data")];
  }

  ManagedContext context;
  FileSystemService fileSystemService = FileSystemService();
  MediaMetaDataService mediaMetaDataService = MediaMetaDataService();

  @Operation.post()
  Future<Response> postForm() async {
    final boundary = request.raw.headers.contentType.parameters["boundary"];
    final transformer = MimeMultipartTransformer(boundary);
    final bodyBytes = await request.body.decode<List<int>>();
    final bodyStream = Stream.fromIterable([bodyBytes]);
    final parts = await transformer.bind(bodyStream).toList();
    int duration;
    String filePath;
    List<Tag> tags;

    for (var part in parts) {
      final HttpMultipartFormData multipart = HttpMultipartFormData.parse(part);
      if (multipart.isText) {
        duration = num.tryParse((await multipart.first).toString()).floor();
      } else {
        final content = multipart.cast<List<int>>();
        filePath = await fileSystemService.saveMediaFile(content);
        tags = await mediaMetaDataService.getTagsFromFile(filePath);
      }
    }
    for (var tag in tags) {
          if (tag.version.contains('2.')) {
            final artUri = await fileSystemService.saveMediaImage(tag.tags['picture'] as AttachedPicture);
            final existingArtistQuery = Query<Author>(context)
              ..where((author) => author.name).equalTo(
                  tag.tags['artist'] as String);
            var existingArtist = await existingArtistQuery.fetchOne();
            if (existingArtist == null) {
              final authorValues = Author()
                ..name = tag.tags['artist'] as String;
              final newArtistQuery = Query<Author>(context)
                ..values = authorValues;
              existingArtist = await newArtistQuery.insert();
            }
            final existingAlbumQuery = Query<Album>(context)
              ..where((album) => album.title).equalTo(
                  tag.tags['album'] as String);

            var existingAlbum = await existingAlbumQuery.fetchOne();
            if (existingAlbum == null) {
              final albumValues = Album()
                ..title = tag.tags['album'] as String
                ..author = existingArtist
                ..year = tag.tags['year'] as String;
              final newAlbumQuery = Query<Album>(context)
                ..values = albumValues;
              existingAlbum = await newAlbumQuery.insert();
            }

            final mediaItemValue = MediaItem()
              ..title = tag.tags['title'] as String
              ..uri = filePath
              ..artUri = artUri
              ..album = existingAlbum
              ..author = existingArtist
              ..duration = duration;
            final mediaInsert = Query<MediaItem>(context)..values = mediaItemValue;
            await mediaInsert.insert();
          } else if (tag.type.contains('1.')) {

          }
    }
    return Response.ok({});
  }
}
