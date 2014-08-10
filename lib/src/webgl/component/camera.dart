part of mathematics;




abstract class Camera extends Component {

  Color backgroundColor = Color.black();
  RenderTargetTexture renderTargetTexture;

  Matrix4 _view;
  Matrix4 _projection;
  Matrix4 _viewProjection;
  Matrix4 _normal;

  Vector3 target;
  Vector3 upVector = WORLD_UP;

  StreamSubscription _worldMatrixChanged;

  Camera() {
    _view = new Matrix4.zero();
  }

  void lookAt(Vector3 center) {
    if (entity == null || entity.transform == null) throw new Exception("entity is null or transform is null.");
    if (target == null) target = new Vector3.zero();
    target.copyFrom(center);
    entity.transform.updateMatrix(false);
    _view.lookAt(entity.transform.worldPosition, center, upVector);
    updateProjection();
  }

  void updateProjection();

  @override
  _entityAdded(GameObject entity) {
    _worldMatrixChanged = entity.on("worldMatrixChanged").listen((Transform transform) {
      _view.copyForm(transform.worldMatrix);
      _view.invert();
      _viewProjection = _projection * _view;
    });

    if(entity.root is Scene) {
      entity.scene.addCamera(this);
    }
  }

  @override
  void _entityRemoved(GameObject entity) {
    if(entity.scene != null) entity.scene.removeCamera(this);
    _cleanup();
  }
  
  @override 
  void _addedToScene(Scene scene) {
    entity.scene.addCamera(this);
  }
  
  @override
  void _removedFromScene() {
    Engine._sharedInstance.scene.removeCamera(this);
  }

  @override
  void dispose() {
    _cleanup();
  }

  void _cleanup() {
    if (_worldMatrixChanged != null) {
      _worldMatrixChanged.cancel();
      _worldMatrixChanged = null;
    }
  }

  Matrix4 get viewProjection => _viewProjection;
  Matrix4 get projection => _projection;
  Matrix4 get view => _view;
}
