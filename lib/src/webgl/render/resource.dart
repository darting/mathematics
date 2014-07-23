part of mathematics;




abstract class Resource implements Disposable {
  static int _globalID = 0;
  static String autoID() => "Res${++_globalID}";

  String _id;
  String get id => _id;

  Resource([String id]) {
    if (id == null) id = autoID();
    _id = id;
  }
  
  Engine get engine => Engine._sharedInstance;
  GraphicsDevice get graphicsDevice => engine._graphics;

  bool _ready = false;
  bool get ready => _ready;
}
