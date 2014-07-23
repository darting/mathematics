part of mathematics;




class Renderer extends Component {

  Color _backgroundColor;

  Renderer(this._backgroundColor) {

  }

  @override
  void _targetAdded(Node target) {
    if (target._renderer != null) throw new Exception("There cannot be two Renderer on the same node.");



  }

  @override
  void _targetRemoved(Node target) {
    // TODO: implement _targetRemoved
  }

  void render(GraphicsDevice graphics, Texture renderTarget) {

    // event
    // rendertarget

    graphics.clear(_backgroundColor.red, _backgroundColor.green, _backgroundColor.blue, _backgroundColor.alpha);

    List<DrawCall> drawCalls;

    drawCalls.forEach((drawCall) {
      drawCall.render(graphics, renderTarget);
    });
    
    graphics.flush();
    
    // event

  }
}








