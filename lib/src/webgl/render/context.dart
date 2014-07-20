part of mathematics;




class Context {
  static const int SIZE_FLOAT = 4;

  html.CanvasElement _renderingCanvas;
  html.CanvasElement get renderingCanvas => _renderingCanvas;
  gl.RenderingContext _ctx;
  DeviceCapabilities _caps;
  math.Rectangle _viewport;

  List<gl.Buffer> _vertexBuffers = [];
  List<gl.Buffer> _indexBuffers = [];
  
  bool _currentColorMask;
  bool _currentDepthMask;
  int _currentDepthFunc;
  gl.Buffer _currentIndexBuffer;
  List<gl.Buffer> _currentVertexBuffer = [];
  List<int> _currentVertexSize = [];
  List<int> _currentVertexStride = [];
  List<int> _currentVertexOffset = [];

  Context(this._renderingCanvas) {
    _ctx = _renderingCanvas.getContext3d(preserveDrawingBuffer: true);
    _caps = new DeviceCapabilities(_ctx);
    // init
    _ctx.enable(gl.DEPTH_TEST);
    _ctx.enable(gl.BLEND);
    _ctx.enable(gl.CULL_FACE);
    _ctx.cullFace(gl.BACK);
    _ctx.frontFace(gl.CCW);
    setColorMask(true);
    setDepthTest(true, gl.LESS);
  }

  void configureViewport(int x, int y, int width, int height) {
    if (_viewport == null || _viewport.left != x || _viewport.right != y || _viewport.width != width
        || _viewport.height != height) {
      _viewport = new math.Rectangle(x, y, width, height);
      _ctx.viewport(_viewport.left, _viewport.right, _viewport.width, _viewport.height);
    }
  }

  // TODO
  // 0,0,0,0,1,0xffffff
  void clear(double red, double green, double blue, double alpha, double depth, int stencil, int
      mask) {
    _ctx.clearColor(red, green, blue, alpha);
    _ctx.clearDepth(depth);
    _ctx.clearStencil(stencil);
    mask = (gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT | gl.STENCIL_BUFFER_BIT) & mask;
    if (mask & gl.DEPTH_BUFFER_BIT == gl.DEPTH_BUFFER_BIT) {
      _currentDepthMask = true;
      _ctx.depthMask(_currentDepthMask);
    }
    _ctx.clear(mask);
  }

  void setDepthTest(bool depthMask, int depthFunc) {
    if (depthMask != _currentDepthMask || depthFunc != _currentDepthFunc) {
      _currentDepthMask = depthMask;
      _currentDepthFunc = depthFunc;
      _ctx.depthMask(depthMask);
      _ctx.depthFunc(depthFunc);
    }
  }

  void setColorMask(bool colorMask) {
    if (_currentColorMask != colorMask) {
      _currentColorMask = colorMask;
      _ctx.colorMask(_currentColorMask, _currentColorMask, _currentColorMask, _currentColorMask);
    }
  }

  void present() {
    _ctx.flush();
  }

  void drawTriangles(gl.Buffer indexBuffer, int numTriangles) {
    if (_currentIndexBuffer != indexBuffer) {
      _currentIndexBuffer = indexBuffer;
      _ctx.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
    }
    _ctx.drawElements(gl.TRIANGLES, numTriangles * 3, gl.UNSIGNED_SHORT, 0);
  }

  gl.Buffer createVertexBuffer(int size) {
    var buffer = _ctx.createBuffer();
    _ctx.bindBuffer(gl.ARRAY_BUFFER, buffer);
    _ctx.bufferData(gl.ARRAY_BUFFER, size * SIZE_FLOAT, gl.STATIC_DRAW);
    _vertexBuffers.add(buffer);
    return buffer;
  }

  void uploadVertexBufferData(gl.Buffer vertexBuffer, int offset, data) {
    _ctx.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
    _ctx.bufferSubData(gl.ARRAY_BUFFER, offset * SIZE_FLOAT, data);
  }

  void deleteVertexBuffer(gl.Buffer vertexBuffer) {
    if (_currentVertexBuffer.contains(vertexBuffer)) _currentVertexBuffer.remove(vertexBuffer);
    _vertexBuffers.remove(vertexBuffer);
    _ctx.deleteBuffer(vertexBuffer);
  }

  void setVertexBufferAt(int position, gl.Buffer vertexBuffer, int size, int stride, int offset) {
    var current = _currentVertexBuffer[position];
    if (current == vertexBuffer && _currentVertexSize[position] == size &&
        _currentVertexStride[position] == stride && _currentVertexOffset[position] == position) return;

    _currentVertexBuffer[position] = vertexBuffer;
    _currentVertexSize[position] = size;
    _currentVertexStride[position] = stride;
    _currentVertexOffset[position] = offset;

    if (vertexBuffer != null) {
      _ctx.enableVertexAttribArray(position);
    } else {
      _ctx.disableVertexAttribArray(position);
      return;
    }

    _ctx.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
    _ctx.vertexAttribPointer(position, size, gl.FLOAT, false, stride * SIZE_FLOAT, offset *
        SIZE_FLOAT);
  }
  
  gl.Buffer createIndexBuffer(int size) {
    var buffer = _ctx.createBuffer();
    _ctx.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, buffer);
    _currentIndexBuffer = buffer;
    _ctx.bufferData(gl.ELEMENT_ARRAY_BUFFER, size * SIZE_FLOAT, gl.STATIC_DRAW);
    _indexBuffers.add(buffer);
    return buffer;
  }
  
  void uploaderIndexBufferData(gl.Buffer indexBuffer, int offset, int size, data) {
    _ctx.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
    _currentIndexBuffer = indexBuffer;
    _ctx.bufferSubData(gl.ELEMENT_ARRAY_BUFFER, offset * SIZE_FLOAT, data);
  }
  
  void deleteIndexBuffer(gl.Buffer indexBuffer) {
    if(_currentIndexBuffer == indexBuffer) _currentIndexBuffer = null;
    _indexBuffers.remove(indexBuffer);
    _ctx.deleteBuffer(indexBuffer);
  }
  
  gl.Texture createTexture() {
    // TODO
  }


}



class DeviceCapabilities {
  int maxTexturesImageUnits;
  num maxTextureSize;
  num maxCubemapTextureSize;
  num maxRenderTextureSize;
  bool standardDerivatives;
  gl.CompressedTextureS3TC s3tc;
  bool textureFloat;
  gl.ExtTextureFilterAnisotropic textureAnisotropicFilterExtension;
  num maxAnisotropy;
  gl.AngleInstancedArrays instancedArrays;

  DeviceCapabilities(gl.RenderingContext ctx) {
    maxTexturesImageUnits = ctx.getParameter(gl.MAX_TEXTURE_IMAGE_UNITS);
    maxTextureSize = ctx.getParameter(gl.MAX_TEXTURE_SIZE);
    maxCubemapTextureSize = ctx.getParameter(gl.MAX_CUBE_MAP_TEXTURE_SIZE);
    maxRenderTextureSize = ctx.getParameter(gl.MAX_RENDERBUFFER_SIZE);

    // extensions
    standardDerivatives = (ctx.getExtension('OES_standard_derivatives') != null);

    s3tc = ctx.getExtension('WEBGL_compressed_texture_s3tc');
    textureFloat = (ctx.getExtension('OES_texture_float') != null);
    textureAnisotropicFilterExtension = ctx.getExtension('EXT_texture_filter_anisotropic');
    if (textureAnisotropicFilterExtension == null) textureAnisotropicFilterExtension =
        ctx.getExtension('WEBKIT_EXT_texture_filter_anisotropic');
    if (textureAnisotropicFilterExtension == null) textureAnisotropicFilterExtension =
        ctx.getExtension('MOZ_EXT_texture_filter_anisotropic');
    if (textureAnisotropicFilterExtension == null) {
      maxAnisotropy = 0;
    } else {
      maxAnisotropy = ctx.getParameter(gl.ExtTextureFilterAnisotropic.MAX_TEXTURE_MAX_ANISOTROPY_EXT
          );
    }
    instancedArrays = ctx.getExtension('ANGLE_instanced_arrays');
  }
}

























