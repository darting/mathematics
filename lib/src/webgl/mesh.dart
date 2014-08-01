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

  VertexBuffer _tangents;
  VertexBuffer get tangents => _tangents;
  set tangents(data) => _tangents = _newVertexBuffer(data, 3);

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

  void computeTangentSpace() {

    var tan1 = new List<Vector3>.generate(_vertices.numVertices, (i) => new Vector3.zero());
    var tan2 = new List<Vector3>.generate(_vertices.numVertices, (i) => new Vector3.zero());

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

        var w1 = getUV(i1);
        var w2 = getUV(i1);
        var w3 = getUV(i1);

        var v1 = p2 - p1;
        var v2 = p3 - p1;

        var s1 = w2 - w1;
        var s2 = w3 - w1;

        var r = 1.0 / (s1.x * s2.y - s2.x * s1.y);
        var sdir = new Vector3((s2.y * v1.x - s1.y * v2.x) * r, (s2.y * v1.y - s1.y * v2.y) * r, (s2.y * v1.z - s1.y * v2.z) * r);
        var tdir = new Vector3((s1.x * v2.x - s2.x * v1.x) * r, (s1.x * v2.y - s2.x * v1.y) * r, (s1.x * v2.z - s2.x * v1.z) * r);

        tan1[i1] += sdir;
        tan1[i2] += sdir;
        tan1[i3] += sdir;

        tan2[i1] += tdir;
        tan2[i2] += tdir;
        tan2[i3] += tdir;
      }

      for (var i = 0; i < count; i++) {
        var vi = indices[i];
        var n = getNormal(vi);
        var t = tan1[vi];
        var tan = (t - n * n.dot(t)).normalize();
        setTangents(vi, tan);
        // TODO Calculate handedness
        //   -> tan.w = (Dot(Cross(n, t), tan2[a]) < 0.0F) ? -1.0F : 1.0F;
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

  Vector2 getUV(int index) {
    index *= 2;
    var data = _uv._data as Float32List;
    return new Vector2(data[index], data[index + 1]);
  }

  Vector2 getUV2(int index) {
    index *= 2;
    var data = _uv2._data as Float32List;
    return new Vector2(data[index], data[index + 1]);
  }
  
  Vector3 getTangents(int index) {
    index *= 3;
    var data = _tangents._data as Float32List;
    return new Vector3(data[index], data[index + 1], data[index + 2]);
  }
  
  void setTangents(int index, tangents) {
    index *= 3;
    var data = _tangents._data as Float32List;
    data[index] = tangents[0];
    data[index + 1] = tangents[1];
    data[index + 2] = tangents[2];
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
