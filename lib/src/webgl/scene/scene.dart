part of mathematics;




class Scene extends GameObject {

  final List<Camera> renderTargets = [];
  final List<Camera> cameras = [];
  final List<Light> lights = [];
  final Map<String, Object> dataProvider = {};

  Iterable<Camera> getRenderTargets() => renderTargets.where((c) => c.enabled);
  
  Camera get mainCamera => cameras.firstWhere((c) => c.enabled);

  DrawCallPool _drawCalls = new DrawCallPool();
  
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

  void _registerRenderer(Renderer renderer) {
    _drawCalls.register(renderer);
  }

  void _unregisterRenderer(Renderer renderer) {
    _drawCalls.unregister(renderer);
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

    var renderTargets = getRenderTargets();
    renderTargets.forEach((camera) {
      _drawCalls.render(graphics, camera);
    });

    if (renderTargets.length > 0) graphics.restoreDefaultFramebuffer();

    var camera = mainCamera;
    graphics.clear(camera.backgroundColor);
    _drawCalls.render(graphics, camera);
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




















