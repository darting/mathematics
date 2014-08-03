part of mathematics;




class PhongMaterial extends Material {

  Texture diffuseTexture;

  PhongMaterial() {
    technique = new Technique();
    technique.add(new Pass("default", new Shader.load("packages/mathematics/src/webgl/shaders/phong")));
  }

  @override
  bool ready(GraphicsDevice graphics, GameObject entity) {
    if (diffuseTexture == null || !diffuseTexture.ready) return false;

    var shader = technique.defaultPass.shader;
    shader.prepare(graphics);
    return shader.ready;
  }

  @override
  void bind(GraphicsDevice graphics, Camera camera, GameObject entity) {
    graphics.uniformMatrix4("uModelMat", entity.transform.worldMatrix);

    var mesh = entity.meshInstance.mesh;
    var shader = technique.defaultPass.shader;

    graphics.bindTexture("diffuseSampler", diffuseTexture);
    
    graphics.uniformVector3("uEyePosition", camera.entity.transform.worldPosition);
    
    mesh.vertices.enable(graphics, shader.attributes["aPosition"]);
    mesh.normals.enable(graphics, shader.attributes["aNormal"]);
    mesh.uv.enable(graphics, shader.attributes["aUV"]);
  }
}






































