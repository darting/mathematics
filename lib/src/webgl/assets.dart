part of mathematics;




class Assets {

  Map<String, Mesh> _meshes = {};

  void addMesh(Mesh mesh) {
    if (_meshes.containsKey(mesh.id)) throw new Exception("${mesh.id} must be unique id");
    _meshes[mesh.id] = mesh;
  }

  Mesh getMesh(String id) => _meshes[id];
}
