import 'package:aqueduct/aqueduct.dart';
import 'package:music_service/model/media_item.dart';
import 'package:music_service/music_service.dart';

class FavouritesController extends ResourceController {
  FavouritesController(this.context);

  ManagedContext context;

  @Operation.post()
  Future<Response> toggleFavourite() async {
    final Map<String, dynamic> body = await request.body.decode();
    final existingMediaItemQuery = Query<MediaItem>(context)
      ..where((m) => m.id).equalTo(body['id'] as int);
    final existingMediaItem = await existingMediaItemQuery.fetchOne();
    if (existingMediaItem !=null) {
      final query = Query<MediaItem>(context)
        ..values.favourite = !existingMediaItem.favourite
        ..where((m) => m.id).equalTo(body['id'] as int);
      await query.updateOne();
      return Response.ok({});
    }
    return Response.notFound();
  }
}