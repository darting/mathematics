part of mathematics;




class DrawCall {

  Material _material;
  List<GameObject> _entities = [];

  DrawCall(this._material);

  void combine(GameObject entity) {
    _entities.add(entity);
  }

  void separate(GameObject entity) {
    _entities.remove(entity);
  }

  void render(GraphicsDevice graphics, Camera camera) {
    if (_material.ready(graphics, null)) {
      graphics.use(_material.technique.defaultPass);

      graphics.uniformMatrix4("uViewMat", camera.view);
      graphics.uniformMatrix4("uProjectionMat", camera.projection);

      _entities.forEach((entity) {
        _material.bind(graphics, camera, entity);
        var mesh = entity.meshInstance.mesh;
        mesh._subMeshes.forEach((subMesh) {
          subMesh._indices.bind(graphics);
          graphics.drawTriangles(subMesh._indices);
        });
      });
    }
  }
}
