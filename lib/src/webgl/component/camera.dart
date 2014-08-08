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
  StreamSubscription _addToScene;
  StreamSubscription _removeFromScene;

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
    _addToScene = entity.on("addToScene").listen((_) {
      entity.scene.addCamera(this);
    });
    _removeFromScene = entity.on("removeFromScene").listen((_) {
      entity.scene.removeCamera(this);
    });
  }

  @override
  void _entityRemoved(GameObject entity) {
    _cleanup();
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
    if (_addToScene != null) {
      _addToScene.cancel();
      _addToScene = null;
    }
    if (_removeFromScene != null) {
      _removeFromScene.cancel();
      _removeFromScene = null;
    }
  }

  Matrix4 get viewProjection => _viewProjection;
  Matrix4 get projection => _projection;
  Matrix4 get view => _view;
}
