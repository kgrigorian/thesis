import 'dart:html';

void main() {
  final dropArea = querySelector('#drop-area');
  final body = BodyElement();
  ProgressElement progressBar = querySelector('#progress-bar');
  InputElement filElem = querySelector('#fileElem');
  var uploadProgress = [];


  void preventDefaults(MouseEvent event) {
    event.preventDefault();
    event.stopPropagation();
  }

  body.onDragEnter.listen(preventDefaults);
  dropArea.onDragEnter.listen(preventDefaults);
  body.onDragOver.listen(preventDefaults);
  dropArea.onDragOver.listen(preventDefaults);
  body.onDragLeave.listen(preventDefaults);
  dropArea.onDragLeave.listen(preventDefaults);
  body.onDrop.listen(preventDefaults);
  dropArea.onDrop.listen(preventDefaults);

  void highlight(event) {
    dropArea.classes.add('highlight');
  }

  void unhighlight(event) {
    dropArea.classes.remove('highlight');
  }

  dropArea.onDragEnter.listen(highlight);
  dropArea.onDragOver.listen(highlight);

  dropArea.onDrop.listen(unhighlight);
  dropArea.onDragLeave.listen(unhighlight);


  void initializeProgress(int numFiles) {
    progressBar.value = 0;
    uploadProgress = [];

    for (var i = numFiles; i > 0; i--) {
      uploadProgress.add(0);
    }
  }

  void updateProgress(int fileNumber, percent) {
    uploadProgress[fileNumber] = percent;
    var total = uploadProgress.reduce((tot, curr) => tot + curr) /
        uploadProgress.length;
    progressBar.value = total;
  }

  void previewFile(File file) {
    var reader = FileReader();
    reader.readAsDataUrl(file);
    reader.onLoadEnd.listen((e) {
      var li = LIElement();
      li.text = file.name;
      querySelector('#list-media').append(li);
    });
  }

  void uploadFile(File file, int index) {
    FileReader()
      ..readAsDataUrl(file)
      ..onLoad.listen((dynamic e) {
        var audio = AudioElement()
          ..src = e.target.result;
        audio.onLoadedMetadata.listen((e) {
          final durationMiliseconds = (audio.duration * 1000).toString();
          final url = 'http://localhost:8888/upload';
          var xhr = HttpRequest();
          var formData = FormData();
          xhr.open('POST', url);
          xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
          xhr.upload.onProgress.listen((e) =>
              updateProgress(index, e.loaded * 100.0 / e.total));
          xhr.addEventListener('readystatechange', (e) {
            if (xhr.readyState == 4 && xhr.status == 200) {
              updateProgress(index, 100);
            }
          });

          formData.appendBlob('file', file);
          formData.append('duration', durationMiliseconds.toString());
          xhr.send(formData);
        });
      });
  }


    void handleFiles(List<File> files) {
      initializeProgress(files.length);
      files.asMap().forEach((index, file) => uploadFile(file, index));
      files.forEach(previewFile);
    }

    void handleDrop(MouseEvent e) {
      var dt = e.dataTransfer;
      var files = dt.files;
      handleFiles(files);
    }

    filElem.onChange.listen((e) => handleFiles(filElem.files));
    dropArea.onDrop.listen(handleDrop);
  }
