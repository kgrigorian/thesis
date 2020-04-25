import 'dart:html';
import 'uploader.dart';

void main() {
  DivElement dropArea = querySelector('#drop-area');
  ProgressElement progressBar = querySelector('#progress-bar');
  InputElement filElem = querySelector('#fileElem');
  DragNDropUploaderArea uploader = DragNDropUploaderArea(
    'http://localhost:8888/upload',
    dropArea,
    progressBar,
  );

  filElem.onChange.listen((e) => uploader.handleFiles(filElem.files));
}
