part of mathematics;




class PhysicallyBasedRenderMaterial extends Material {

  // Albedo is the base color input, commonly known as a diffuse map.
  // 0.0 ~ 1.0
  double albedo = 1.0;
  // defines how rough or smooth the surface of a material is.
  // 0.0 ~ 1.0
  double roughness = 0.7;
  // F0
  double reflectivity = 0.3;

  Texture diffuseTexture;

  PhysicallyBasedRenderMaterial() {
    technique = new Technique();
    technique.add(new Pass("default", new Shader.load("packages/mathematics/src/webgl/shaders/physically")));
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
    
    mesh.vertices.enable(graphics, shader.attributes["aPosition"]);
    mesh.normals.enable(graphics, shader.attributes["aNormal"]);
    mesh.uv.enable(graphics, shader.attributes["aDiffuseUV"]);
  }
}






































