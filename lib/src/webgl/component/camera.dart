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

  Vector3 lookAtTarget;
  Vector3 upVector = WORLD_UP;

  StreamSubscription _worldMatrixChanged;

  Camera() {
    cameras.add(this);
    _view = new Matrix4.zero();
  }

  void lookAt(Vector3 center) {
    if (target == null || target.transform == null) throw new Exception("target is null or transform is null.");
    if (lookAtTarget == null) lookAtTarget = new Vector3.zero();
    lookAtTarget.copyFrom(center);
    target.transform.updateMatrix(false);
    _view.lookAt(target.transform.worldPosition, center, upVector);
    updateProjection();
  }

  void updateProjection();

  @override
  _targetAdded(Node target) {
    _worldMatrixChanged = target.on("worldMatrixChanged").listen((Transform transform) {
      _view.copyForm(transform.worldMatrix);
      _view.invert();
      _viewProjection = _projection * _view;
    });
  }

  @override
  void _targetRemoved(Node target) {
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
