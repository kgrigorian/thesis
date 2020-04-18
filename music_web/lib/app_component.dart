import 'package:angular/angular.dart';

@Component(
  selector: 'my-app',
  template: '''<div id="drop-area">
      <form class="my-form">
<p>Upload multiple files with the file dialog or by dragging and dropping images onto the dashed region</p>
<input type="file" id="fileElem" multiple accept="audio/*">
<label class="button" for="fileElem">Select some files</label>
</form>
<progress id="progress-bar" max=100 value=0></progress>
<div id="gallery" /></div>
    </div>
    ''',
)
class AppComponent {
  var name = 'Angular';
}