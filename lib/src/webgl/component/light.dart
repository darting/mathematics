part of mathematics;




abstract class Light extends Component {
  Color color;
  double intensity;
  double range = double.MAX_FINITE;
  
  
  Texture cookie;
  int shadowType;
  double darkness;
  int resolution;
  
  void bind(GraphicsDevice graphics, int lightIndex);
}


class DirectionalLight extends Light {
  Vector3 direction;
  
  double cookieSize;
  
  DirectionalLight({this.direction}) {
    if(direction == null)
      direction = new Vector3(0.0, 0.0, -1.0);
  }

  @override
  void bind(GraphicsDevice graphics, int lightIndex) {
    direction.normalize();
    graphics.uniformFloat4("uLightData$lightIndex", direction.x, direction.y, direction.z, 1.0);
  }
}


class PointLight extends Light {
  
  @override
  void bind(GraphicsDevice graphics, int lightIndex) {
    var position = entity.transform.worldPosition;
    graphics.uniformFloat4("uLightData$lightIndex", position.x, position.y, position.z, 0.0);
  }
}


class SpotLight extends Light {
  double exponent;
  double angle = 0.8;
  Vector3 direction;
  
  SpotLight(this.direction) {
    if (direction == null) direction = new Vector3(0.0, -1.0, 0.0);
  }

  @override
  void bind(GraphicsDevice graphics, int lightIndex) {
    direction.normalize();
    var position = entity.transform.worldPosition;
    graphics.uniformFloat4("uLightData$lightIndex", position.x, position.y, position.z, exponent);
    graphics.uniformFloat4("uLightDirection$lightIndex", direction.x, direction.y, direction.z, math.cos(angle * 0.5));
  }
}


class HemisphericLight extends Light {
  Color groundColor = new Color.fromHex(0x0);
  Vector3 direction;
  
  HemisphericLight(this.direction) {
    if (direction == null) direction = new Vector3(0.0, 1.0, 0.0);
  }

  @override
  void bind(GraphicsDevice graphics, int lightIndex) {
    direction.normalize();
    graphics.uniformFloat4("uLightData$lightIndex", direction.x, direction.y, direction.z, 0.0);
    var color = groundColor.clone().scale(intensity);
    graphics.uniformFloat3("uLightGround$lightIndex", color.red, color.green, color.blue);
  }
}