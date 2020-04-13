abstract class Environment {
  String get api;
}

class DebugEnvironment implements Environment {
  @override
  String get api => 'http://192.168.0.187:8888';
}

class ReleaseEnviroment implements Environment {
  @override
  String get api => '...';
}
