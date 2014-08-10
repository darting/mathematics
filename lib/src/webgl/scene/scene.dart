part of mathematics;




class Scene extends GameObject {

  final List<Camera> renderTargets = [];
  final List<Camera> cameras = [];
  final List<Light> lights = [];
  final Map<String, Object> dataProvider = {};

  Camera get mainCamera => cameras.firstWhere((c) => c.enabled);

  DrawCallPool _drawCalls = new DrawCallPool();
  
  final WorldRenderer worldRenderer = new WorldRenderer();
  final List<Renderer> renderer = [];
  final List<GameObject> opaqueObjectes = [];
  final List<GameObject> alphaTestObjectes = [];
  final List<GameObject> transparentObjectes = [];
  
  
  Color ambientColor = Color.white();

  Scene() : super("Scene") {
    root = this;
  }

  @override
  void addChild(Node child) {
    var object = child as GameObject;
    if (object == null) throw new Exception("Just can add GameObject to scene");
    super.addChild(object);
    object.updateRoot(this);
  }

  void _registerRenderer(Surface renderer) {
    _drawCalls.register(renderer);
    
    opaqueObjectes.add(renderer.entity);
  }

  void _unregisterRenderer(Surface renderer) {
    _drawCalls.unregister(renderer);
    
    opaqueObjectes.remove(renderer.entity);
  }

  void _updateGameObject(GameObject entity) {
    entity.components.forEach((c) {
      c.update();
    });
    if (entity._children != null) entity._children.forEach(_updateGameObject);
  }

  void update() {
    _children.forEach(_updateGameObject);

    var graphics = Engine._sharedInstance._graphics;

    //renderTargets.forEach((renderTarget) => _drawCalls.render(graphics, renderTarget));

    if (renderTargets.length > 0) graphics.restoreDefaultFramebuffer();

    worldRenderer.render(graphics, mainCamera, this);
    
//    var camera = mainCamera;
//    graphics.clear(camera.backgroundColor);
    //_drawCalls.render(graphics, camera);
    
//    opaqueObjectes.forEach((GameObject entity){
//      entity.surface.sharedMaterials.forEach((m) => _render(graphics, camera, m, [entity]));
//    });
  }

  void addCamera(Camera camera) {
    if (camera.renderTargetTexture != null) {
      renderTargets.add(camera);
    } else {
      cameras.add(camera);
    }
  }

  void removeCamera(Camera camera) {
    if (camera.renderTargetTexture != null) {
      renderTargets.remove(camera);
    } else {
      cameras.remove(camera);
    }
  }
  
}




















