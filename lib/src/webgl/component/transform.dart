part of mathematics;




class Transform extends Component {
  Vector3 _position;
  Vector3 worldPosition;
  Vector3 _scaling;
  Quaternion _rotation;
  Matrix4 _localMatrix;
  Matrix4 worldMatrix;
  bool _dirty;

  Transform() {
    _position = new Vector3.zero();
    worldPosition = new Vector3.zero();
    _scaling = new Vector3.all(1.0);
    _rotation = new Quaternion.identity();
    _localMatrix = new Matrix4.identity();
    _dirty = true;
  }

  void set scaling(Vector3 val) {
    _scaling.copyFrom(val);
    _dirty = true;
  }

  void set rotation(Quaternion val) {
    _rotation.copyFrom(val);
    _dirty = true;
  }

  void set position(Vector3 val) {
    _position.copyFrom(val);
    _dirty = true;
  }

  void translate(dynamic x, [double y = 0.0, double z = 0.0]) {
    if (x is Vector3) {
      _position.add(x);
    } else {
      _position.x += x;
      _position.y += y;
      _position.z += z;
    }
    _dirty = true;
  }

  void rotateX(double rad) {
    _rotation.rotateX(rad);
    _dirty = true;
  }

  void rotateY(double rad) {
    _rotation.rotateY(rad);
    _dirty = true;
  }

  void rotateZ(double rad) {
    _rotation.rotateZ(rad);
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

    if (worldMatrix == null || _dirty) {
      if (target.parent != null && target.parent.transform != null) {
        worldMatrix = target.parent.transform.worldMatrix * _localMatrix;
      } else {
        worldMatrix = _localMatrix.clone();
      }
      worldPosition.setValues(worldMatrix[12], worldMatrix[13], worldMatrix[14]);
    }

    _dirty = false;

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
    updateMatrix(true);
  }
}
