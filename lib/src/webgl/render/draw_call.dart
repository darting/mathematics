part of mathematics;




class DrawCall {

  Surface _renderer;
  List<GameObject> _entities = [];

  DrawCall(this._renderer);

  void combine(GameObject entity) {
    _entities.add(entity);
  }

  void separate(GameObject entity) {
    _entities.remove(entity);
  }

  void render(GraphicsDevice graphics, Camera camera) {
    _renderer.sharedMaterials.forEach((m) => _render(graphics, camera, m));
  }

  void _render(GraphicsDevice graphics, Camera camera, Material material) {
    if (material.ready(graphics, _renderer)) {
      graphics.use(material.technique.defaultPass);

      graphics.uniformMatrix4("uViewMat", camera.view);
      graphics.uniformMatrix4("uProjectionMat", camera.projection);

      _entities.forEach((entity) {
        material.bind(graphics, camera, entity);
        var mesh = entity.meshInstance.mesh;
        mesh._subMeshes.forEach((subMesh) {
          subMesh._indices.bind(graphics);
          graphics.drawTriangles(subMesh._indices);
        });
      });
    }
  }
}
