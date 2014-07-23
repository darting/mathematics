part of mathematics;




abstract class Resource implements Disposable {

  GraphicsDevice get graphicsDevice => Engine._sharedInstance._graphics;

  bool _ready = false;
  bool get ready => _ready;
}
