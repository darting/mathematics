part of mathematics;




typedef enterFrame();


class Stage {

  num _elapsedTime = 0.0;
  num _deltaTime = 0.0;
  num _fps = 60;
  
  num get elapsedTime => _elapsedTime;
  num get deltaTime => _deltaTime;
  num get fps => _fps;
  
  GraphicsDevice _graphics;
  num _sourceWidth;
  num _sourceHeight;
  
  Callback enterFrame;
  
  Stage(html.CanvasElement canvas) {
    _graphics = new GraphicsDevice(canvas);
    _sourceWidth = canvas.width;
    _sourceHeight = canvas.height;
    // TODO resize
    // TODO context lose
  }

  run() => html.window.requestAnimationFrame(_animate);

  void _animate(num highResTime) {
    run();

    final delta = highResTime - _elapsedTime;
    _elapsedTime = highResTime;
    _deltaTime = delta;
    
    if(enterFrame != null) enterFrame();
    
    
  }
}
