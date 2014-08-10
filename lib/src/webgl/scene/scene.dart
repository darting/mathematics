part of mathematics;




class Scene extends GameObject {

  final List<Camera> renderTargets = [];
  final List<Camera> cameras = [];
  final List<Light> lights = [];
  final Map<String, Object> dataProvider = {};

  Camera get mainCamera => cameras.firstWhere((c) => c.enabled);

  DrawCallPool _drawCalls = new DrawCallPool();
  
  WorldRenderer _worldRenderer = new WorldRenderer();
  final List<Renderer> renderer = [];
  final List<GameObject> opaqueRenderables = [];
  final List<GameObject> alphaTestRenderables = [];
  final List<GameObject> transparentRenderables = [];
  
  
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
    
    opaqueRenderables.add(renderer.entity);
  }

  void _unregisterRenderer(Surface renderer) {
    _drawCalls.unregister(renderer);
    
    opaqueRenderables.remove(renderer.entity);
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

    renderTargets.forEach((Camera camera) => camera.renderTarget.render(graphics, camera, this));

    if (renderTargets.length > 0) graphics.restoreDefaultFramebuffer();

    _worldRenderer.render(graphics, mainCamera, this);
    
//    var camera = mainCamera;
//    graphics.clear(camera.backgroundColor);
    //_drawCalls.render(graphics, camera);

  }

  void addCamera(Camera camera) {
    if(camera.renderTarget != null) {
      renderTargets.add(camera);
    } else {
      cameras.add(camera);
    }

  }

  void removeCamera(Camera camera) {
    if(camera.renderTarget != null) {
      renderTargets.remove(camera);
    } else {
      cameras.remove(camera);
    }
  }
  
}




















