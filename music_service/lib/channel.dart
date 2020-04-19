import 'package:music_service/controller/favourites_controller.dart';
import 'package:music_service/controller/upload_controller.dart';
import 'package:music_service/service/file_system_service.dart';

import 'model/album.dart';
import 'model/media_item.dart';
import 'music_service.dart';

/// This type initializes an application.
///
/// Override methods in this class to set up routes and initialize services like
/// database connections. See http://aqueduct.io/docs/http/channel/.
class MusicServiceChannel extends ApplicationChannel {
  ManagedContext context;
  FileSystemService fileSystemService;
  /// Initialize services in this method.
  ///
  /// Implement this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore.fromConnectionInfo(
          "admin", "password", "localhost", 5432, "music_service");
    context = ManagedContext(dataModel, psc);
    logger.onRecord.listen(
            (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  /// Construct the request channel.
  ///
  /// Return an instance of some [Controller] that will be the initial receiver
  /// of all [Request]s.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/music/*").link(() => FileController("music/"));
    router.route("/images/*").link(() => FileController("images/"));
    router.route("/favourites").link(() => FavouritesController(context));

    router.route("/all").linkFunction((req) async {
      var query = Query<MediaItem>(context)
        ..join(object: (m) => m.album)
        ..join(object: (m) => m.author);
      var res = await query.fetch();
      return Response.ok(res);
    });

    router.route("/albums").linkFunction((req) async {
      var query = Query<Album>(context)
        ..join(object: (m) => m.author)
        ..join(set: (a) => a.mediaItems);

      var res = await query.fetch();
      return Response.ok(res);
    });

    router.route("/upload").link(() => UploadController(context));

    return router;
  }
}
