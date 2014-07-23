part of mathematics;




class VertexAttribute {
  /** 
   * index of vertex atribute
   */
  int location;
  /**
   * size is number of components per attribute
   */
  int size;
  /**
   * type specifies the data type of the values stored in the array
   */
  int type = gl.FLOAT;
  /**
   * The normalized parameter in the VertexAttribPointer command identifies 
   * whether integer types should be normalized when converted to floating-point.
   */
  bool normalized = false;
  /**
   * Specifies the offset in bytes between the beginning of consecutive vertex attributes. 
   * Default value is 0, maximum is 255. Must be a multiple of type.
   */
  int stride;
  /**
   * Specifies an offset in bytes of the first component of the first vertex attribute in the array. 
   * Default is 0 which means that vertex attributes are tightly packed. Must be a multiple of type.
   */
  int offset;
}

class VertexBuffer extends Resource {
  gl.Buffer _buffer;
  TypedData _data;

  int _target;
  int _usage = gl.STATIC_DRAW;

  int _vertexSize;
  int _numVertices = 0;

  VertexBuffer.vertexData(Float32List data, this._vertexSize) {
    _target = gl.ARRAY_BUFFER;
    _numVertices = data.length ~/ _vertexSize;
    _data = data;
    upload();
  }
  
  VertexBuffer.indexData(Uint16List data) {
    _target = gl.ELEMENT_ARRAY_BUFFER;
    _data = data;
    upload();
  }

  void upload() {
    var ctx = graphicsDevice._ctx;
    if (_buffer == null) {
      _buffer = ctx.createBuffer();
    }
    ctx.bindBuffer(_target, _buffer);
    ctx.bufferDataTyped(_target, _data, _usage);
    _ready = true;
  }

  @override
  void dispose() {
    if (_buffer != null) {
      graphicsDevice._ctx.deleteBuffer(_buffer);
    }
    _ready = false;
    _buffer = null;
  }
}
