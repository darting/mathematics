part of mathematics;




class PhongMaterial extends Material {

  Texture diffuseTexture;

  String _defines;
  StringBuffer _definesBuff;

  PhongMaterial() {
    technique = new Technique();
    _definesBuff =  new StringBuffer();
  }

  @override
  bool ready(GraphicsDevice graphics, Renderer renderer) {
    _definesBuff.clear();
    
    if (diffuseTexture != null) {
      if (!diffuseTexture.ready) return false;
      _definesBuff.writeln("#define DIFFUSE");
    }

    var scene = Engine._sharedInstance.scene;
    for (var i = 0; i < scene.lights.length && i < Light.MAX_LIGHTS; i++) {
      _definesBuff.writeln("#define LIGHT$i");
      var light = scene.lights[i];
      if (light is SpotLight) {
        _definesBuff.writeln("#define SPOTLIGHT$i");
      } else if (light is HemisphericLight) {
        _definesBuff.writeln("#define HEMILIGHT$i");
      } else {
        _definesBuff.writeln("#define POINTDIRLIGHT$i");
      }
    }
    
    _definesBuff.writeln("#define UV1");

    var defines = _definesBuff.toString();
    if (_defines != defines) {
      _defines = defines;
      technique.set(new Pass("default", new Shader.load("packages/mathematics/src/webgl/shaders/phong", common: defines)));
    }
    var shader = technique.defaultPass.shader;
    shader.prepare(graphics);
    return shader.ready;
  }

  @override
  void bind(GraphicsDevice graphics, Camera camera, GameObject entity) {
    graphics.uniformMatrix4("uModelMat", entity.transform.worldMatrix);

    var mesh = entity.meshInstance.mesh;
    var shader = technique.defaultPass.shader;

    if (diffuseTexture != null) graphics.bindTexture("diffuseSampler", diffuseTexture);

    var scene = entity.scene;
    for (var i = 0; i < scene.lights.length && i < Light.MAX_LIGHTS; i++) {
      var light = scene.lights[i];
      light.bind(graphics, i);

      var color = light.diffuseColor;
      var intensity = light.intensity;
      graphics.uniformFloat4("uLightDiffuse${i}", color.red * intensity, color.green * intensity, color.blue * intensity, light.range);
      graphics.uniformColor3("uLightSpecular${i}", light.specularColor.clone().scale(light.intensity));
    }

    graphics.uniformVector3("uEyePosition", camera.entity.transform.worldPosition);

    mesh.vertices.enable(graphics, shader.attributes["aPosition"]);
    mesh.normals.enable(graphics, shader.attributes["aNormal"]);
    mesh.uv.enable(graphics, shader.attributes["aUV"]);
  }
}



































