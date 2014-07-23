part of mathematics;




class Transform extends Component {
  Vector3 _position;
  Vector3 _worldPosition;
  Vector3 _scaling;
  Quaternion _rotation;
  Matrix4 _localMatrix;
  Matrix4 worldMatrix;
  bool _dirty;

  @override
  void _initialize() {
    _position = new Vector3.zero();
    _worldPosition = new Vector3.zero();
    _scaling = new Vector3.all(1.0);
    _rotation = new Quaternion.identity();
    _localMatrix = new Matrix4.identity();
    _dirty = true;
  }

  applyMatrix(Matrix4 m) {
    _localMatrix.copyForm(m);
    _localMatrix.decompose(_position, _rotation, _scaling);
    _dirty = false;
  }

  updateMatrix([bool updateChildren = true]) {
    if (_dirty) {
      _localMatrix.recompose(_position, _rotation, _scaling);
    }
    if (target.parent != null) {
      worldMatrix = target.parent.transform.worldMatrix * _localMatrix;
    } else {
      worldMatrix = _localMatrix.clone();
    }
    _worldPosition.setValues(worldMatrix[12], worldMatrix[13], worldMatrix[14]);

    if (updateChildren && target._children != null) {
      target._children.forEach((c) {
        if (c._transform != null) c._transform.updateMatrix(updateChildren);
      });
    }
  }

  @override
  void _targetAdded(Node target) {
    // TODO: implement _targetAdded
  }

  @override
  void _targetRemoved(Node target) {
    // TODO: implement _targetRemoved
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void _enabledChanged() {
    // TODO: implement _enabledChanged
  }

  @override
  void _receive(String message, data) {
    // TODO: implement _receive
  }

  @override
  void update() {
    // TODO: implement update
  }
}
