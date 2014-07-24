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

  bool ready(GraphicsDevice graphics, Node target) {
    return technique.defaultPass.ready;
  }

  @override
  void bind(GraphicsDevice graphics, Camera camera, Node target) {
    // uniforms
    graphics.uniformMatrix4("uViewMat", camera.view);
    graphics.uniformMatrix4("uModelMat", target.transform.worldMatrix);
    graphics.uniformMatrix4("uProjectionMat", camera.projection);

    // attributes
    var mesh = target.meshInstance.mesh;
    var shader = technique.defaultPass.shader;
    
    mesh.vertices.enable(graphics, shader.attributes["aPosition"]);
    mesh.normals.enable(graphics, shader.attributes["aNormal"]);
    
    
  }
}
