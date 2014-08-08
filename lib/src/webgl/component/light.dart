part of mathematics;




abstract class Light extends Component {
  static const int MAX_LIGHTS = 4;
  
  Color diffuseColor = Color.white();
  Color specularColor = Color.white();
  double intensity = 1.0;
  double range = double.MAX_FINITE;

  Texture cookie;
  int shadowType;
  double darkness;
  int resolution;

  StreamSubscription _addToScene;
  StreamSubscription _removeFromScene;

  @override
  _entityAdded(GameObject entity) {
    super._entityAdded(entity);
    _addToScene = entity.on("addToScene").listen((_) => entity.scene.lights.add(this));
    _removeFromScene = entity.on("removeFromScene").listen((_) => entity.scene.lights.remove(this));
  }

  @override
  void _entityRemoved(GameObject entity) {
    super._entityRemoved(entity);
    if (_addToScene != null) {
      _addToScene.cancel();
      _addToScene = null;
    }
    if (_removeFromScene != null) {
      _removeFromScene.cancel();
      _removeFromScene = null;
    }
  }

  void bind(GraphicsDevice graphics, int lightIndex);
}


class DirectionalLight extends Light {
  Vector3 direction;

  double cookieSize;

  DirectionalLight({this.direction}) {
    if (direction == null) direction = new Vector3(0.0, 0.0, 1.0);
  }

  @override
  void bind(GraphicsDevice graphics, int lightIndex) {
    direction.normalize();
    graphics.uniformFloat4("uLightData$lightIndex", direction.x, direction.y, direction.z, -1.0);
  }

  StreamSubscription _worldMatrixChanged;

  @override
  _entityAdded(GameObject entity) {
    super._entityAdded(entity);
    _worldMatrixChanged = entity.on("worldMatrixChanged").listen(worldMatrixChanged);
  }

  @override
  void _entityRemoved(GameObject entity) {
    super._entityRemoved(entity);
    if (_worldMatrixChanged != null) {
      _worldMatrixChanged.cancel();
      _worldMatrixChanged = null;
    }
  }

  void worldMatrixChanged(Transform transform) {
    direction.setValues(0.0, 0.0, -1.0);
    transform.worldMatrix.rotateRef(direction);
  }
}


class PointLight extends Light {

  @override
  void bind(GraphicsDevice graphics, int lightIndex) {
    var position = entity.transform.worldPosition;
    graphics.uniformFloat4("uLightData$lightIndex", position.x, position.y, position.z, 0.0);
  }
}


class SpotLight extends DirectionalLight {
  double exponent;
  double angle = 0.8;

  SpotLight();

  @override
  void bind(GraphicsDevice graphics, int lightIndex) {
    direction.normalize();
    var position = entity.transform.worldPosition;
    graphics.uniformFloat4("uLightData$lightIndex", position.x, position.y, position.z, exponent);
    graphics.uniformFloat4("uLightDirection$lightIndex", direction.x, direction.y, direction.z, math.cos(angle * 0.5));
  }
}


class HemisphericLight extends DirectionalLight {
  Color groundColor = new Color.fromHex(0x0);

  HemisphericLight() : super(direction: new Vector3(0.0, 1.0, 0.0));

  @override
  void bind(GraphicsDevice graphics, int lightIndex) {
    direction.normalize();
    graphics.uniformFloat4("uLightData$lightIndex", direction.x, direction.y, direction.z, 0.0);
    var color = groundColor.clone().scale(intensity);
    graphics.uniformFloat3("uLightGround$lightIndex", color.red, color.green, color.blue);
  }
}
