part of mathematics;




class BasicMaterial extends Material {
  BasicMaterial({Color color, Texture diffuse, Vector2 offset, Vector2 scale}) {
    this.color = color;
    this.diffuseTexture = diffuse;
    this.diffuseOffset = offset;
    this.diffuseScale = scale;
    technique = new Technique();
    technique.add(new Pass("default", new Shader.load("packages/mathematics/src/webgl/shaders/basic")));
  }

  bool ready(GraphicsDevice graphics, GameObject entity) {
    var shader = technique.defaultPass.shader;
    shader.prepare(graphics);
    return shader.ready;
  }

  @override
  void bind(GraphicsDevice graphics, Camera camera, GameObject entity) {
    // uniforms
    //graphics.uniformMatrix4("uViewMat", camera.view);
    //graphics.uniformMatrix4("uProjectionMat", camera.projection);
    graphics.uniformMatrix4("uModelMat", entity.transform.worldMatrix);

    // attributes
    var mesh = entity.meshInstance.mesh;
    var shader = technique.defaultPass.shader;
    
    mesh.vertices.enable(graphics, shader.attributes["aPosition"]);
    mesh.normals.enable(graphics, shader.attributes["aNormal"]);
    
    
  }
}
