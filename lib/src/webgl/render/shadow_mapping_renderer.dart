part of mathematics;




class ShadowMappingRenderer implements Renderer {
  
  Pass _pass;
  
  ShadowMappingRenderer() {
    _pass = new Pass("shadow_mapping", new Shader.load("packages/mathematics/src/webgl/shaders/shadow_mapping"));
  }
  
  @override
  void render(GraphicsDevice graphics, Camera camera, Scene scene) {
    if(!_pass.ready) return;
    graphics.bindFramebuffer(camera.renderTargetTexture);
    graphics.clear(camera.backgroundColor);
    scene.opaqueRenderables.forEach((renderable) => _draw(graphics, camera, renderable));
  }
  
  void _draw(GraphicsDevice graphics, Camera camera, GameObject renderable) {
    graphics.uniformMatrix4("world", renderable.transform.worldMatrix);
    graphics.uniformMatrix4("viewProjection", camera.viewProjection);
    graphics.bindTexture("diffuseSampler", camera.renderTargetTexture);
    var mesh = renderable.meshInstance.mesh;
    mesh.vertices.enable(graphics, _pass.shader.attributes["position"]);
    mesh._subMeshes.forEach((subMesh) {
      subMesh._indices.bind(graphics);
      graphics.drawTriangles(subMesh._indices);
    });
    if(renderable.children != null)
      renderable.children.forEach((c) => _draw(graphics, camera, c));
  }
  
  
}
