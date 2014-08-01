part of mathematics;




typedef enterFrame();

// http://codeflow.org/entries/2013/feb/22/how-to-write-portable-webgl/
class Engine {

  static Engine _sharedInstance;

  final Scene scene;
  final Assets assets;

  num _totalTime = 0.0;
  num _elapsedTime = 0.0;
  num _fps = 60;

  num get totalTime => _totalTime;
  num get elapsedTime => _elapsedTime;
  num get fps => _fps;

  GraphicsDevice _graphics;
  num _sourceWidth;
  num _sourceHeight;

  Callback enterFrame;
  Callback exitFrame;

  factory Engine(html.CanvasElement canvas) {
    if (_sharedInstance == null) _sharedInstance = new Engine._(canvas);
    return _sharedInstance;
  }

  Engine._(html.CanvasElement canvas)
      : scene = new Scene(),
        assets = new Assets() {
    
    _graphics = new GraphicsDevice(canvas);
    _sourceWidth = canvas.width;
    _sourceHeight = canvas.height;
    
    // TODO resize
    // TODO context lose
  }

  run() => html.window.requestAnimationFrame(_animate);

  void _animate(num highResTime) {
    run();

    final delta = highResTime - _totalTime;
    _totalTime = highResTime;
    _elapsedTime = delta;
    _fps = 1000.0 / delta;

    if (enterFrame != null) enterFrame();

    // physics
    // shadows
    // octree
    // prepare
    // render to target
    // render to stage
    // bounding box
    // particles
    // clear
    scene.update();

    if (exitFrame != null) exitFrame();
  }
}



















