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
  int type;
  /**
   * The normalized parameter in the VertexAttribPointer command identifies 
   * whether integer types should be normalized when converted to floating-point.
   */
  bool normalized;
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

  VertexAttribute(this.size, this.type, this.normalized, this.stride, this.offset);
}

class VertexBuffer extends Resource {
  gl.Buffer _buffer;
  TypedData _data;

  int _target;
  int _usage = gl.STATIC_DRAW;

  // TODO one vertex buffer maybe have multi-attributes.
  VertexAttribute _attribute;

  int _numVertices = 0;
  int get numVertices => _numVertices;
  int get lengthInBytes => _data == null ? 0 : _data.lengthInBytes;

  VertexBuffer.vertexData(Float32List data, int vertexSize) {
    _target = gl.ARRAY_BUFFER;
    _numVertices = data.length ~/ vertexSize;
    _data = data;
    _attribute = new VertexAttribute(vertexSize, gl.FLOAT, false, 0, 0);
  }

  VertexBuffer.indexData(Uint16List data) {
    _target = gl.ELEMENT_ARRAY_BUFFER;
    _numVertices = data.length ~/ 3;
    _data = data;
    _attribute = new VertexAttribute(3, gl.UNSIGNED_SHORT, false, 0, 0);
  }

  void upload(GraphicsDevice graphics) {
    var ctx = graphics._ctx;
    if (_buffer == null) {
      _buffer = ctx.createBuffer();
    }
    ctx.bindBuffer(_target, _buffer);
    ctx.bufferDataTyped(_target, _data, _usage);
    _ready = true;
  }

  void bind(GraphicsDevice graphics) {
    if (_buffer == null) {
      upload(graphics);
    } else {
      graphics._ctx.bindBuffer(_target, _buffer);
    }
  }

  void enable(GraphicsDevice graphics, ShaderProperty attrib) {
    var ctx = graphics._ctx;
    bind(graphics);
    ctx.enableVertexAttribArray(attrib.location);
    ctx.vertexAttribPointer(attrib.location, _attribute.size, _attribute.type, _attribute.normalized, _attribute.stride, _attribute.offset);
  }

  @override
  void dispose() {
    if (_buffer != null) {
      graphicsDevice._ctx.deleteBuffer(_buffer);
    }
    _ready = false;
    _buffer = null;
    _data = null;
  }
}
