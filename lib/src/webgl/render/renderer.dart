part of mathematics;




abstract class Renderer {

  void render(GraphicsDevice graphics, Camera camera, Scene scene);

}


class WorldRenderer implements Renderer {

  @override
  void render(GraphicsDevice graphics, Camera camera, Scene scene) {
    graphics.clear(camera.backgroundColor);
    
    scene.opaqueRenderables.forEach((GameObject entity) {
      entity.surface.sharedMaterials.forEach((m) => _draw(graphics, camera, m, entity));
    });
  }

  void _draw(GraphicsDevice graphics, Camera camera, Material material, GameObject entity) {
    if (material.ready(graphics, entity.surface)) {
      graphics.use(material.technique.defaultPass);

      graphics.uniformMatrix4("uViewMat", camera.view);
      graphics.uniformMatrix4("uProjectionMat", camera.projection);

      material.bind(graphics, camera, entity);
      entity.meshInstance.mesh._subMeshes.forEach((subMesh) {
        subMesh._indices.bind(graphics);
        graphics.drawTriangles(subMesh._indices);
      });
    }
  }
}
