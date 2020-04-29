import 'dart:io';

import 'package:aqueduct/aqueduct.dart';

class MusicServiceConfiguration extends Configuration {
  MusicServiceConfiguration(String fileName) : super.fromFile(File(fileName));
  DatabaseConfiguration database;
}
