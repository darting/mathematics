part of mathematics;




class BasicMaterial extends Material {
  
  Color color;
  Texture texture;

  String _defines;
  StringBuffer _definesBuff;
  
  BasicMaterial([Color color]) {
    this.color = color;
    if(this.color == null) this.color = Color.white();
    technique = new Technique();
    _definesBuff = new StringBuffer();
  }

  @override
  bool ready(GraphicsDevice graphics, Surface surface) {

    _definesBuff.clear();

    if(texture != null) {
      if(!texture.ready) return false;
      _definesBuff.writeln("#define TEXTURE");
    }

    var defines = _definesBuff.toString();
    if (_defines != defines) {
      _defines = defines;
      technique.set(new Pass("default", new Shader.load("packages/mathematics/src/webgl/shaders/basic", common: defines)));
    }

    var shader = technique.defaultPass.shader;
    shader.prepare(graphics);
    return shader.ready;
  }

  @override
  void bind(GraphicsDevice graphics, Camera camera, GameObject entity) {
    graphics.uniformMatrix4("uModelMat", entity.transform.worldMatrix);

    // attributes
    var mesh = entity.meshInstance.mesh;
    var shader = technique.defaultPass.shader;

    graphics.uniformColor3("uColor", color);

    if(texture != null) {
      graphics.bindTexture("texture", texture);
      mesh.uv.enable(graphics, shader.attributes["aUV"]);
    } else {

    }
    
    mesh.vertices.enable(graphics, shader.attributes["aPosition"]);
  }
}
