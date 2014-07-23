part of mathematics;




class Mesh extends Resource {

  Mesh(String id) : super(id);

  int _numVertices = 0;
  int get numVertices => _numVertices;

  List<SubMesh> _subMeshes;

  VertexBuffer _vertices;
  VertexBuffer get vertices => _vertices;
  set vertices(data) => _vertices = _addVertexBuffer(data, 3);

  VertexBuffer _normals;
  VertexBuffer get normals => _normals;
  set normals(data) => _normals = _addVertexBuffer(data, 3);

  VertexBuffer _uv;
  VertexBuffer get uv => _uv;
  set uv(data) => _uv = _addVertexBuffer(data, 2);

  VertexBuffer _uv2;
  VertexBuffer get uv2 => _uv2;
  set uv2(data) => _uv2 = _addVertexBuffer(data, 2);

  VertexBuffer _colors;
  VertexBuffer get colors => _colors;
  set colors(data) => _colors = _addVertexBuffer(data, 4);

  VertexBuffer _colors2;
  VertexBuffer get colors2 => _colors2;
  set colors2(data) => _colors2 = _addVertexBuffer(data, 4);

  VertexBuffer _addVertexBuffer(data, size) {
    VertexBuffer result;
    if (data is VertexBuffer) {
      result = data;
    } else {
      if (!(data is Float32List)) data = new Float32List.fromList(data);
      result = new VertexBuffer.vertexData(data, size);
    }
    _numVertices += result._numVertices;
    return result;
  }

  void setIndices(data, {int subMesh: 0, int topology: gl.TRIANGLES}) {
    if (_subMeshes == null) _subMeshes = [];
    SubMesh sub;
    if (_subMeshes.length <= subMesh) {
      sub = new SubMesh().._material = _subMeshes.length;
    } else {
      sub = _subMeshes[subMesh];
    }
    if (!(data is VertexBuffer)) {
      if (!(data is Uint16List)) data = new Uint16List.fromList(data);
      data = new VertexBuffer.indexData(data);
    }
    sub._indices = data;
  }
  
  VertexBuffer getIndices([int subMesh = 0]) {
    if(_subMeshes == null || _subMeshes.length >= subMesh) return null;
    return _subMeshes[subMesh]._indices;
  }


  void computeNormals() {

  }

  void computeTangentSpace([bool normals]) {

  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}

class SubMesh {
  int _material;
  VertexBuffer _indices;
}
