import 'package:aqueduct/aqueduct.dart';
import 'package:music_service/music_service.dart';

class FavouritesController extends ResourceController {
  FavouritesController(this.context);

  ManagedContext context;

  @Operation.post()
  Future<Response> postForm() async {

  }
}