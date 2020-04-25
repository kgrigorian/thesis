import 'dart:html';

class DragNDropUploaderArea {
  DragNDropUploaderArea(
    this.endpoint,
    this.dropArea,
    this.progressBar,
  ) {
    dropArea.onDragEnter.listen((e) => _highlight());
    dropArea.onDragOver.listen((e) => _highlight());
    dropArea.onDrop.listen((e) => _unhighlight());
    dropArea.onDragLeave.listen((e) => _unhighlight());
    dropArea.onDrop.listen(_handleDrop);
  }

  ProgressElement progressBar;
  DivElement dropArea;
  String endpoint;
  List<int> uploadProgress;

  // public methods
  void handleFiles(List<File> files) {
    _initializeProgress(files.length);
    files.asMap().forEach((index, file) => _uploadFile(file, index));
    files.forEach(_addToList);
  }

  // private methods
  void _initializeProgress(int numFiles) {
    progressBar.value = 0;
    uploadProgress = [];

    for (var i = numFiles; i > 0; i--) {
      uploadProgress.add(0);
    }
  }

  void _handleDrop(MouseEvent e) {
    var dt = e.dataTransfer;
    var files = dt.files;
    handleFiles(files);
  }

  void _addToList(File file) {
    var reader = FileReader();
    reader.readAsDataUrl(file);
    reader.onLoadEnd.listen((e) {
      var li = LIElement();
      li.text = file.name;
      querySelector('#list-media').append(li);
    });
  }

  void _uploadFile(File file, int index) {
    FileReader()
      ..readAsDataUrl(file)
      ..onLoad.listen((dynamic e) {
        var audio = AudioElement()..src = e.target.result;
        audio.onLoadedMetadata.listen((e) {
          final durationMiliseconds = (audio.duration * 1000).toString();
          final url = endpoint;
          var xhr = HttpRequest();
          var formData = FormData();
          xhr.open('POST', url);
          xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
          xhr.upload.onProgress.listen(
              (e) => _updateProgress(index, e.loaded * 100.0 / e.total));
          xhr.addEventListener('readystatechange', (e) {
            if (xhr.readyState == 4 && xhr.status == 200) {
              _updateProgress(index, 100);
            }
          });

          formData.appendBlob('file', file);
          formData.append('duration', durationMiliseconds.toString());
          xhr.send(formData);
        });
      });
  }

  void _updateProgress(int fileNumber, percent) {
    uploadProgress[fileNumber] = percent;
    var total = uploadProgress.reduce((tot, curr) => tot + curr) /
        uploadProgress.length;
    progressBar.value = total;
  }

  void _highlight() {
    dropArea.classes.add('highlight');
  }

  void _unhighlight() {
    dropArea.classes.remove('highlight');
  }
}
