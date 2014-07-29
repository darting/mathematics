part of mathematics;




class Mesh extends Resource {

  Mesh(String id) : super(id);

  int _numVertices = 0;
  int get numVertices => _numVertices;

  List<SubMesh> _subMeshes;

  VertexBuffer _vertices;
  VertexBuffer get vertices => _vertices;
  set vertices(data) => _vertices = _newVertexBuffer(data, 3);

  VertexBuffer _normals;
  VertexBuffer get normals => _normals;
  set normals(data) => _normals = _newVertexBuffer(data, 3);

  VertexBuffer _uv;
  VertexBuffer get uv => _uv;
  set uv(data) => _uv = _newVertexBuffer(data, 2);

  VertexBuffer _uv2;
  VertexBuffer get uv2 => _uv2;
  set uv2(data) => _uv2 = _newVertexBuffer(data, 2);

  VertexBuffer _colors;
  VertexBuffer get colors => _colors;
  set colors(data) => _colors = _newVertexBuffer(data, 4);

  VertexBuffer _colors2;
  VertexBuffer get colors2 => _colors2;
  set colors2(data) => _colors2 = _newVertexBuffer(data, 4);

  VertexBuffer _newVertexBuffer(data, size) {
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
      _subMeshes.add(sub);
    } else {
      sub = _subMeshes[subMesh];
    }
    if (!(data is VertexBuffer)) {
      if (!(data is Uint16List)) data = new Uint16List.fromList(data);
      data = new VertexBuffer.indexData(data);
    }
    sub._indices = data;
  }

  int get numSubMeshes => _subMeshes == 0 ? 0 : _subMeshes.length;

  VertexBuffer getIndices([int subMesh = 0]) {
    if (_subMeshes == null || _subMeshes.length <= subMesh) return null;
    return _subMeshes[subMesh]._indices;
  }

  void computeNormals() {
    normals = new Float32List(_vertices.numVertices * 3);

    var len = numSubMeshes;
    for (var i = 0; i < len; i++) {
      var indices = getIndices(i)._data as Uint16List;
      var count = indices.length;
      for (var f = 0; f < count; f += 3) {
        var i1 = indices[f];
        var i2 = indices[f + 1];
        var i3 = indices[f + 2];

        var p1 = getVertex(i1);
        var p2 = getVertex(i2);
        var p3 = getVertex(i3);

        var v1 = p2 - p1;
        var v2 = p3 - p1;
        var normal = v1.cross(v2);

        setNormal(i1, getNormal(i1) + normal);
        setNormal(i2, getNormal(i2) + normal);
        setNormal(i3, getNormal(i3) + normal);
      }
    }
  }
  
  Vector3 getVertex(int index) {
    index *= 3;
    var data = _vertices._data as Float32List;
    return new Vector3(data[index], data[index + 1], data[index + 2]);
  }
  
  Vector3 getNormal(int index) {
    index *= 3;
    var data = _normals._data as Float32List;
    return new Vector3(data[index], data[index + 1], data[index + 2]);
  }
  
  void setNormal(int index, normal) {
    index *= 3;
    var data = _normals._data as Float32List;
    data[index] = normal[0];
    data[index + 1] = normal[1];
    data[index + 2] = normal[2];
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
