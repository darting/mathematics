part of mathematics;




class Renderer extends Component {

  Color _backgroundColor;
  BoundingInfo _bounds;
  bool castShadows;
  bool enabled;
  bool visible;
  int lightmapIndex;
  Vector4 lightmapTilingOffset;
  Material material;
  Material sharedMaterial;
  List<Material> materials;
  List<Material> sharedMaterials;
  bool receiveShadows;
  
  Renderer() {
    _backgroundColor = Color.black();
  }

  @override
  void _targetAdded(Node target) {
    if (target._renderer != null) throw new Exception("There cannot be two Renderer on the same node.");



  }

  @override
  void _targetRemoved(Node target) {
    // TODO: implement _targetRemoved
  }

  void render([Texture renderTarget]) {

    // event
    // rendertarget
    
    var graphics = Engine._sharedInstance._graphics;

    graphics.clear(_backgroundColor.red, _backgroundColor.green, _backgroundColor.blue, _backgroundColor.alpha);

    List<DrawCall> drawCalls;

    drawCalls.forEach((drawCall) {
      drawCall.render(graphics, renderTarget);
    });
    
    graphics.flush();
    
    // event

  }
}








