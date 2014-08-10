part of mathematics;




class ShadowMapping extends RenderTargetTexture implements Renderer {

  RenderTargetTexture _renderTarget;
  Pass _pass;
  
  ShadowMapping() : super("shadow_mapping") {
    width = 512;
    height = 512;
  }

  @override
  void prepare(GraphicsDevice graphics) {
    super.prepare(graphics);
    if(_pass == null) {
      _pass = new Pass("shadow_mapping", new Shader.load("packages/mathematics/src/webgl/shaders/shadow_mapping"));
    }
    _pass.shader.prepare(graphics);
  }

  bool get ready => super.ready && _pass != null && _pass.ready;

  @override
  void render(GraphicsDevice graphics, Camera camera, Scene scene) {

    if(_pass == null || !_pass.ready) return;

    graphics.bindFramebuffer(_renderTarget);
    graphics.clear(camera.backgroundColor);
    scene.opaqueRenderables.forEach((renderable) => _draw(graphics, camera, renderable));
  }
  
  void _draw(GraphicsDevice graphics, Camera camera, GameObject renderable) {
    if(!renderable.surface.castShadows)
      return;

    graphics.uniformMatrix4("world", renderable.transform.worldMatrix);
    graphics.uniformMatrix4("viewProjection", camera.viewProjection);
    graphics.bindTexture("diffuseSampler", this);
    var mesh = renderable.meshInstance.mesh;
    mesh.vertices.enable(graphics, _pass.shader.attributes["position"]);
    mesh._subMeshes.forEach((subMesh) {
      subMesh._indices.bind(graphics);
      graphics.drawTriangles(subMesh._indices);
    });
    if(renderable.children != null)
      renderable.children.forEach((c) => _draw(graphics, camera, c));
  }

  @override
  void dispose() {
    _pass.dispose();
  }


}
