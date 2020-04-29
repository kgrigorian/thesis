import 'package:music_service/controller/favourites_controller.dart';
import 'package:music_service/controller/upload_controller.dart';
import 'package:music_service/music_service_configuration.dart';
import 'package:music_service/service/file_system_service.dart';

import 'model/album.dart';
import 'model/media_item.dart';
import 'music_service.dart';

class MusicServiceChannel extends ApplicationChannel {
  ManagedContext context;
  FileSystemService fileSystemService;
  List<WebSocket> connectedSockets = [];
  /// Initialize services in this method.
  ///
  /// Implementing this method to initialize services, read values from [options]
  /// and any other initialization required before constructing [entryPoint].
  ///
  /// This method is invoked prior to [entryPoint] being accessed.
  @override
  Future prepare() async {
    final config = MusicServiceConfiguration(options.configurationFilePath);
    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();
    final psc = PostgreSQLPersistentStore.fromConnectionInfo(
        config.database.username,
        config.database.password,
        config.database.host,
        config.database.port,
        config.database.databaseName);
    context = ManagedContext(dataModel, psc);
    messageHub.listen((event) {
      if (event is Map && event["event"] == "radiolist_file_change_broadcast") {
        connectedSockets.forEach((socket) {
          socket.add(event["message"]);
        });
      }
    });
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));
  }

  /// Constructing the request channel.
  ///
  /// This method is invoked after [prepare].
  @override
  Controller get entryPoint {
    final router = Router();

    router.route("/music/*").link(() => FileController("music/"));
    router.route("/images/*").link(() => FileController("images/"));
    router.route("/favourites").link(() => FavouritesController(context));

    router.route("/connect").linkFunction((request) async {
    final socket = await WebSocketTransformer.upgrade(request.raw);
    connectedSockets.add(socket);
    return null;
    });


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

    router.route("/kek").linkFunction((req) async {
      connectedSockets.forEach((socket) => socket.add('mmmm'));
      return Response.ok({});
    }
    );

    return router;
  }

  void onFileUpdate() {
    connectedSockets.forEach((socket) {
      socket.add('dd');
    });
    messageHub.add({"event": "radiolist_file_change_broadcast"});
  }
}
