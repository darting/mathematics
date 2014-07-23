part of mathematics;




class PerspectiveCamera extends Component {
  double _fov;
  double _aspect;
  double _near;
  double _far;

  Matrix4 _view;
  Matrix4 _projection;
  Matrix4 _viewProjection;

  Vector3 _position;
  Matrix4 _postProjection;

  PerspectiveCamera(this._aspect, {double fov: 0.785, double near: 0.1, double far: 1000.0, Matrix4 postProjection}) {
    _fov = fov;
    _near = near;
    _far = far;
    _postProjection = postProjection;
    _initialize();
  }

  void _initialize() {
    _view = new Matrix4.zero();
    _projection = new Matrix4.perspective(_fov, _aspect, _near, _far);
    _viewProjection = _projection.clone();
    _position = new Vector3.zero();
  }

  void set fieldOfView(double fov) {
    if (_fov != fov) {
      _fov = fov;
      updateProjection();
    }
  }

  void set aspectRatio(double aspectRatio) {
    if (_aspect != aspectRatio) {
      _aspect = aspectRatio;
      updateProjection();
    }
  }

  void set near(double near) {
    if (_near != near) {
      _near = near;
      updateProjection();
    }
  }

  void set far(double far) {
    if (_far != far) {
      _far = far;
      updateProjection();
    }
  }

  void updateProjection() {
  }

  void unproject(double x, double y, Ray ref) {

  }

  void updateMatrix(Matrix4 world) {
    _view.copyForm(world);
    _view.copyTranslation(_position);
    _view.invert();
    updateProjection();
  }
  
  StreamSubscription _worldMatrixChanged;

  @override
  _targetAdded(Node target) {
    _worldMatrixChanged = target.on("worldMatrixChanged").listen((e) {

    });
  }

  @override
  void _targetRemoved(Node target) {
    _worldMatrixChanged.cancel();
    _worldMatrixChanged = null;
  }
}
