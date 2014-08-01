part of mathematics;




class Transform extends Component {
  Vector3 _position;
  Vector3 _scaling;
  Quaternion _rotation;
  Matrix4 _localMatrix;
  
  bool _localDirty;
  bool _worldDirty;

  Vector3 worldPosition;
  Matrix4 worldMatrix;

  Transform() {
    _position = new Vector3.zero();
    worldPosition = new Vector3.zero();
    _scaling = new Vector3.all(1.0);
    _rotation = new Quaternion.identity();
    _localMatrix = new Matrix4.identity();
    _worldDirty = true;
    _localDirty = true;
  }
  
  Vector3 get scaling => _scaling;

  void set scaling(Vector3 val) {
    _scaling.copyFrom(val);
    _localDirty = true;
  }
  
  Quaternion get rotation => _rotation;

  void set rotation(Quaternion val) {
    _rotation.copyFrom(val);
    _localDirty = true;
  }
  
  Vector3 get position => _position;

  void set position(Vector3 val) {
    _position.copyFrom(val);
    _localDirty = true;
  }

  void translate(dynamic x, [double y = 0.0, double z = 0.0]) {
    if (x is Vector3) {
      _position.add(x);
    } else {
      _position.x = x;
      _position.y = y;
      _position.z = z;
    }
    _localDirty = true;
  }

  void rotateX(double rad) {
    _rotation.rotateX(rad);
    _localDirty = true;
  }

  void rotateY(double rad) {
    _rotation.rotateY(rad);
    _localDirty = true;
  }

  void rotateZ(double rad) {
    _rotation.rotateZ(rad);
    _localDirty = true;
  }

  applyMatrix(Matrix4 m) {
    _localMatrix.copyForm(m);
    _localMatrix.decompose(_position, _rotation, _scaling);
    _localDirty = false;
    _worldDirty = true;
  }

  updateMatrix([bool updateChildren = true]) {
    if (_localDirty) {
      _localMatrix.recompose(_position, _rotation, _scaling);
      _worldDirty = true;
    }

    if (worldMatrix == null || _worldDirty) {
      if (entity.parent != null && entity.parent.transform != null) {
        worldMatrix = entity.parent.transform.worldMatrix * _localMatrix;
      } else {
        worldMatrix = _localMatrix.clone();
      }
      worldPosition.setValues(worldMatrix[12], worldMatrix[13], worldMatrix[14]);

      entity.on("worldMatrixChanged").dispatch(this);
    }

    _localDirty = _worldDirty = false;

    if (updateChildren && entity._children != null) {
      entity._children.forEach((c) {
        if (c._transform != null) c._transform.updateMatrix(updateChildren);
      });
    }
  }

  @override
  void _entityAdded(Entity entity) {
    // TODO: implement _targetAdded
  }

  @override
  void _entityRemoved(Entity entity) {
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
