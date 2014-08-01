part of mathematics;




abstract class Camera extends Component {

  static final List<Camera> cameras = [];

  static Iterable<Camera> getRenderTargets() => cameras.where((c) => c.enabled && c.renderTargetTexture != null);
  static Iterable<Camera> getSceneCameras() => cameras.where((c) => c.enabled && c.renderTargetTexture == null);

  static Camera get main => cameras.firstWhere((c) => c.enabled && c.renderTargetTexture == null);
  static Camera current;

  RenderTargetTexture renderTargetTexture;

  Matrix4 _view;
  Matrix4 _projection;
  Matrix4 _viewProjection;

  Vector3 target;
  Vector3 upVector = WORLD_UP;

  StreamSubscription _worldMatrixChanged;

  Camera() {
    cameras.add(this);
    _view = new Matrix4.zero();
  }

  void lookAt(Vector3 center) {
    if (entity == null || entity.transform == null) throw new Exception("target is null or transform is null.");
    if (target == null) target = new Vector3.zero();
    target.copyFrom(center);
    entity.transform.updateMatrix(false);
    _view.lookAt(entity.transform.worldPosition, center, upVector);
    updateProjection();
  }

  void updateProjection();

  @override
  _entityAdded(Entity entity) {
    _worldMatrixChanged = entity.on("worldMatrixChanged").listen((Transform transform) {
      _view.copyForm(transform.worldMatrix);
      _view.invert();
      _viewProjection = _projection * _view;
    });
  }

  @override
  void _entityRemoved(Entity entity) {
    _worldMatrixChanged.cancel();
    _worldMatrixChanged = null;
  }

  @override
  void dispose() {
    cameras.remove(this);
  }

  Matrix4 get viewProjection => _viewProjection;
  Matrix4 get projection => _projection;
  Matrix4 get view => _view;
}
