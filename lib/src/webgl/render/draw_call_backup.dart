part of mathematics;



/**
 * refer: http://docs.unity3d.com/Manual/DrawCallBatching.html
 * 
 * for better rendering performance, we can combine a number of objects
 * at runtime and draws them together with a single draw call.
 * 
 * 1. only objects sharing the same material can be batched together.
 * 2. if two materials only differ in textures, we can combine those textures into a single big texture
 *    called texture atlasing.
 * 
 * 3. dynamic batching have vertex limit.
 * 
 * 4. static batching
 *    static objects can not move, rotate and scale in the game.
 *    static batching will require additional memory for storing the combined geometry.
 *    if sereval objects shared the same geometry before static batching. then a copy of geometry will be created
 *    for each object.
 */
class DrawCall2 {
  Material _material;
  List<Matrix4> _modelMatrices = [];
  List<GameObject> _entities = [];
  List<double> _vertices = [];
  List<double> _normals = [];
  List<double> _uv = [];
  List<double> _uv2 = [];
  List<double> _colors = [];
  List<double> _colors2 = [];
  List<int> _indices = [];
  
  int get numEntities => _entities.length;

  DrawCall2(this._material);

  void combine(GameObject entity) {
    _entities.add(entity);
    _setup(entity);
  }

  void separate(GameObject entity) {
    _entities.remove(entity);
    clearData();
    _entities.forEach(_setup);
  }

  void _setup(GameObject entity) {
    var mesh = entity.meshInstance.mesh;
    _vertices.addAll(mesh._vertices._data as Float32List);
    mesh._subMeshes.forEach((m) => _indices.addAll(m._indices._data as Uint8List));
    if (mesh._normals != null) _normals.addAll(mesh._normals._data as Float32List);
    if (mesh._uv != null) _uv.addAll(mesh._uv._data as Float32List);
    if (mesh._uv2 != null) _uv2.addAll(mesh._uv2._data as Float32List);
    if (mesh._colors != null) _colors.addAll(mesh._colors._data as Float32List);
    if (mesh._colors2 != null) _colors2.addAll(mesh._colors2._data as Float32List);
    if(entity.transform != null) {
      entity.transform.updateMatrix(false);
      _modelMatrices.add(entity.transform.worldMatrix);
    } else {
      _modelMatrices.add(new Matrix4.identity());
    }
  }

  void render(GraphicsDevice graphics, Camera camera) {
    
    var pass = _material.technique.defaultPass;
    var shader = pass.shader;
    
    shader.prepare(graphics);
    
    if(!shader.ready) return;
    
    graphics.use(pass);
    
    graphics.uniformMatrix4("uViewMat", camera.view);
    graphics.uniformMatrix4("uProjectionMat", camera.projection);
    
    
//    graphics.uniformMatrix4("uModelMat", entity.transform.worldMatrix);
//    
//    
//    
//    if (_material.ready(graphics, entity)) {
//      graphics.use(_material.technique.defaultPass);
//
//      _material.bind(graphics, camera, entity);
//
//      mesh._subMeshes.forEach((subMesh) {
//        subMesh._indices.bind(graphics);
//        graphics.drawTriangles(subMesh._indices);
//      });
//
//      graphics.flush();
//    }
    
  }

  void clear() {
    _entities.clear();
    clearData();
  }

  void clearData() {
    _vertices.clear();
    _normals.clear();
    _uv.clear();
    _uv2.clear();
    _colors.clear();
    _colors2.clear();
  }
}
































