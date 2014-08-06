part of mathematics;




class BasicMaterial extends Material {
  BasicMaterial([Color color]) {
    this.color = color;
    technique = new Technique();
    technique.add(new Pass("default", new Shader.load("packages/mathematics/src/webgl/shaders/basic")));
  }

  @override
  bool ready(GraphicsDevice graphics, Renderer renderer) {
    var shader = technique.defaultPass.shader;
    shader.prepare(graphics);
    return shader.ready;
  }

  @override
  void bind(GraphicsDevice graphics, Camera camera, GameObject entity) {
    graphics.uniformMatrix4("uModelMat", entity.transform.worldMatrix);
    
    if(color == null) color = Color.white();
    graphics.uniformColor3("uColor", color);

    // attributes
    var mesh = entity.meshInstance.mesh;
    var shader = technique.defaultPass.shader;
    
    mesh.vertices.enable(graphics, shader.attributes["aPosition"]);
  }
}
