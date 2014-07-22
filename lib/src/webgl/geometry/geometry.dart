part of mathematics;




class Geometry {

  int _vertexSize = 0;
  int _numVertices = 0;
  Map<String, VertexBuffer> _vertexBuffers = {};
  VertexBuffer _indexBuffer;

  addVertexBuffer(String name, VertexBuffer vertexBuffer) {
    if (_vertexBuffers.containsKey(name)) throw new ArgumentError("${name} is exist.");
    _vertexBuffers[name] = vertexBuffer;
    _numVertices += vertexBuffer._numVertices;
  }
  
  VertexBuffer getVertexBuffer(String name) {
    return _vertexBuffers[name];
  }
  
  void removeVertexBuffer(String name) {
    _vertexBuffers.remove(name);
  }
  
  bool hasVertexBuffer(String name) => _vertexBuffers.containsKey(name);
  
  void set indices(VertexBuffer indices) {
    _indexBuffer = indices;
  }
  
  int get vertexSize => _vertexSize;
  
  int get numVertices => _numVertices;
  
  void computeNormals() {
    
  }
  
  void computeTangentSpace([bool normals]) {
    
  }
  
  void upload() {
    
  }
}
