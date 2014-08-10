part of mathematics;




abstract class Light extends Component {
  static const int MAX_LIGHTS = 4;
  
  static const int SHADOW_NONE = 0;
  static const int SHADOW_HARD = 1;
  static const int SHADOW_SOFT_VSM = 2;
  
  Color diffuseColor = Color.white();
  Color specularColor = Color.white();
  double intensity = 1.0;
  double range = double.MAX_FINITE;

  Texture cookie;
  
  Camera _shadowCamera;
  int _shadows = SHADOW_NONE;
  int get shadows => _shadows;
  void set shadows(int val) {
    if(_shadows == val) return;
    _shadows = val;
    _ensureShadows();
  }

  void _ensureShadows() {
    if(_shadows == SHADOW_NONE && _shadowCamera != null) {
      entity.removeComponent(_shadowCamera);
    } else if(_shadows != SHADOW_NONE && _shadowCamera == null) {
      _shadowCamera = new PerspectiveCamera(1.0, fov: 90.0, near: 0.1, far: 100.0);
      _shadowCamera.renderTargetTexture = new RenderTargetTexture(id)..width=512..height=512;
      if(entity != null) {
        entity.addComponent(_shadowCamera);
      }
    }
  }
  
  double darkness = 1.0;
  double shadowBias = 0.2;
  
  int resolution;

  @override
  _entityAdded(GameObject entity) {
    super._entityAdded(entity);
    _ensureShadows();
    if(entity.root is Scene) {
      entity.scene.lights.add(this);
    }
  }

  @override
  void _entityRemoved(GameObject entity) {
    super._entityRemoved(entity);
  }
  
  @override 
  void _addedToScene(Scene scene) {
    entity.scene.lights.add(this);
  }
  
  @override
  void _removedFromScene() {
    entity.scene.lights.remove(this);
  }

  void bind(GraphicsDevice graphics, int lightIndex);
}


class DirectionalLight extends Light {
  Vector3 direction;

  double cookieSize;

  DirectionalLight({this.direction}) {
    if (direction == null) direction = new Vector3(0.0, 0.0, -1.0);
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
  double exponent = 3.0;
  double angle = 1.0;

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
  
  @override
  void worldMatrixChanged(Transform transform) {
      direction.setValues(0.0, 1.0, 0.0);
      transform.worldMatrix.rotateRef(direction);
    }
}
