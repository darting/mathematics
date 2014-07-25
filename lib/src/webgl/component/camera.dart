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

  Vector3 _lookAtTarget;
  Vector3 _upVector = WORLD_UP;

  bool _dirty = true;

  Camera() {
    cameras.add(this);
    _view = new Matrix4.zero();
    _lookAtTarget = new Vector3.zero();
  }

  void updateProjection();

  void lookAt(Vector3 target) {
    _lookAtTarget.copyFrom(target);
  }

  @override
  void update() {
//    if (_dirty) {
      _dirty = false;
      if (target != null && target.transform != null) {
        target.transform.updateMatrix(false);
        _view.lookAt(target.transform.worldPosition, _lookAtTarget, _upVector);
        _viewProjection = _projection * _view;
      }
//    }
  }

  Matrix4 get viewProjection => _viewProjection;
  Matrix4 get projection => _projection;
  Matrix4 get view => _view;
  Vector3 get lookAtTarget => _lookAtTarget;

}
