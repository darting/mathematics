part of mathematics;




abstract class Resource implements Disposable {
  GraphicsDevice _graphcisDevice;
  GraphicsDevice get graphicsDevice => _graphcisDevice;
  
  bool _ready = false;
  bool get ready => _ready;
  
  Resource(this._graphcisDevice);
  
  void upload();
}
