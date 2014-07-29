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

  bool _dirty = true;

  Camera() {
    cameras.add(this);
    _view = new Matrix4.zero();
  }

  void updateProjection();

  Matrix4 get viewProjection => _viewProjection;
  Matrix4 get projection => _projection;
  Matrix4 get view => _view;
}
