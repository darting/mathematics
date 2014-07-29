part of mathematics;




class GraphicsDevice {
  static const int SIZE_FLOAT = 4;

  static const int ALPHA_DISABLE = 0;
  static const int ALPHA_ADD = 1;
  static const int ALPHA_COMBINE = 2;

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
  VertexBuffer _currentIndexBuffer;
  List<gl.Buffer> _currentVertexBuffer = new List(8);
  List<int> _currentVertexSize = [];
  List<int> _currentVertexStride = [];
  List<int> _currentVertexOffset = [];
  gl.Texture _currentBoundTexture;

  List<gl.Texture> _textures = [];
  List<gl.Texture> _currentTexture = new List(8);
  Map<gl.Texture, math.Point> _textureSizes = {};
  Map<gl.Texture, bool> _textureHasMipmaps = {};
  Map<gl.Texture, int> _textureTypes = {};
  Map<gl.Texture, Sampler> _currentSamplers = {};

  GraphicsDevice(this._renderingCanvas) {
    _ctx = _renderingCanvas.getContext3d(preserveDrawingBuffer: true);
    if (_ctx == null) throw new Exception("WebGL is not supported");

    _caps = new DeviceCapabilities(_ctx);
    // init
    _ctx.enable(gl.DEPTH_TEST);
    _ctx.disable(gl.BLEND);
    _ctx.enable(gl.CULL_FACE);
    setColorMask(true);
    setDepthTest(true, gl.LEQUAL);
    
    configureViewport(0, 0, _renderingCanvas.width, _renderingCanvas.height);
  }

  void configureViewport(int x, int y, int width, int height) {
    if (_viewport == null || _viewport.left != x || _viewport.right != y || _viewport.width != width || _viewport.height != height) {
      _viewport = new math.Rectangle(x, y, width, height);
      _ctx.viewport(_viewport.left, _viewport.top, _viewport.width, _viewport.height);
    }
  }
  
  void restoreDefaultFramebuffer() {
    _ctx.bindFramebuffer(gl.FRAMEBUFFER, null);
    _ctx.viewport(_viewport.left, _viewport.right, _viewport.width, _viewport.height);
  }

  // TODO
  // 0,0,0,0,1,0xffffff
  void clear(Color color, {double depth: 1.0, int stencil, int mask: gl.COLOR_BUFFER_BIT}) {
    _ctx.clearColor(color.red, color.green, color.blue, color.alpha);
    _ctx.clearDepth(depth);
    // TODO _ctx.clearStencil(stencil);
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

  void flush() {
    _ctx.flush();
  }

  void drawTriangles(VertexBuffer indexBuffer, {int numTriangles, int offset: 0}) {
    if (_currentIndexBuffer != indexBuffer) {
      _currentIndexBuffer = indexBuffer;
      _ctx.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer._buffer);
    }
    if (numTriangles == null) numTriangles = indexBuffer._numVertices;
    _ctx.drawElements(gl.TRIANGLES, numTriangles * 3, gl.UNSIGNED_SHORT, offset);
  }

  //  gl.Buffer createVertexBuffer(int size) {
  //    var buffer = _ctx.createBuffer();
  //    _ctx.bindBuffer(gl.ARRAY_BUFFER, buffer);
  //    _ctx.bufferData(gl.ARRAY_BUFFER, size * SIZE_FLOAT, gl.STATIC_DRAW);
  //    _vertexBuffers.add(buffer);
  //    return buffer;
  //  }
  //
  //  void uploadVertexBufferData(gl.Buffer vertexBuffer, int offset, data) {
  //    _ctx.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
  //    _ctx.bufferSubData(gl.ARRAY_BUFFER, offset * SIZE_FLOAT, data);
  //  }
  //
  //  void deleteVertexBuffer(gl.Buffer vertexBuffer) {
  //    if (_currentVertexBuffer.contains(vertexBuffer)) _currentVertexBuffer.remove(vertexBuffer);
  //    _vertexBuffers.remove(vertexBuffer);
  //    _ctx.deleteBuffer(vertexBuffer);
  //  }

  //  void setVertexBufferAt(int position, gl.Buffer vertexBuffer, int size, int stride, int offset) {
  //    var current = _currentVertexBuffer[position];
  //    if (current == vertexBuffer && _currentVertexSize[position] == size && _currentVertexStride[position] == stride && _currentVertexOffset[position] == position) return;
  //
  //    _currentVertexBuffer[position] = vertexBuffer;
  //    _currentVertexSize[position] = size;
  //    _currentVertexStride[position] = stride;
  //    _currentVertexOffset[position] = offset;
  //
  //    if (vertexBuffer != null) {
  //      _ctx.enableVertexAttribArray(position);
  //    } else {
  //      _ctx.disableVertexAttribArray(position);
  //      return;
  //    }
  //
  //    _ctx.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
  //    _ctx.vertexAttribPointer(position, size, gl.FLOAT, false, stride * SIZE_FLOAT, offset * SIZE_FLOAT);
  //  }

  //  gl.Buffer createIndexBuffer(int size) {
  //    var buffer = _ctx.createBuffer();
  //    _ctx.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, buffer);
  //    _currentIndexBuffer = buffer;
  //    _ctx.bufferData(gl.ELEMENT_ARRAY_BUFFER, size * SIZE_FLOAT, gl.STATIC_DRAW);
  //    _indexBuffers.add(buffer);
  //    return buffer;
  //  }

  void uploaderIndexBufferData(VertexBuffer indexBuffer, int offset, int size, data) {
    _ctx.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer._buffer);
    _currentIndexBuffer = indexBuffer;
    _ctx.bufferSubData(gl.ELEMENT_ARRAY_BUFFER, offset * SIZE_FLOAT, data);
  }

  //  void deleteIndexBuffer(gl.Buffer indexBuffer) {
  //    if (_currentIndexBuffer == indexBuffer) _currentIndexBuffer = null;
  //    _indexBuffers.remove(indexBuffer);
  //    _ctx.deleteBuffer(indexBuffer);
  //  }

  //  gl.Texture createTexture(int textureType, int width, int height, bool mipMapping, bool optimizeForRenderToTexture) {
  //    if (width & (width - 1) != 0) throw new ArgumentError("make sure width is a power of 2");
  //    if (height & (height - 1) != 0) throw new ArgumentError("make sure height is a power of 2");
  //
  //    var texture = _ctx.createTexture();
  //    _ctx.bindTexture(textureType, texture);
  //    _currentBoundTexture = texture;
  //
  //    var sampler = Sampler.defaultSampler;
  //    _ctx.texParameteri(textureType, gl.TEXTURE_WRAP_S, sampler.wrapS);
  //    _ctx.texParameteri(textureType, gl.TEXTURE_WRAP_T, sampler.wrapT);
  //    _ctx.texParameteri(textureType, gl.TEXTURE_MIN_FILTER, sampler.minFilter);
  //    _ctx.texParameteri(textureType, gl.TEXTURE_MAG_FILTER, sampler.magFilter);
  //
  //    _textures.add(texture);
  //    _textureSizes[texture] = new math.Point(width, height);
  //    _textureHasMipmaps[texture] = mipMapping;
  //    _textureTypes[texture] = textureType;
  //    _currentSamplers[texture] = sampler;
  //
  //    // TODO use @{_ctx.generateMipmap}
  //    if (mipMapping) {
  //      var level = 0;
  //      var h = height;
  //      var w = width;
  //      for (var size = width > height ? width : height; size > 0; size = size >> 1, w = w >> 1, h = h >> 1) {
  //        _texImage2D(textureType, level, w, h);
  //        level++;
  //      }
  //    } else {
  //      _texImage2D(textureType, 0, width, height);
  //    }
  //
  //    if (optimizeForRenderToTexture) {
  //      // TODO
  //    }
  //
  //    return texture;
  //  }
  //
  //  void _texImage2D(int textureType, int level, int w, int h) {
  //    if (textureType == gl.TEXTURE_2D) {
  //      _ctx.texImage2D(textureType, level, gl.RGBA, w, h, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
  //    } else {
  //      _ctx.texImage2D(gl.TEXTURE_CUBE_MAP_POSITIVE_X, level, gl.RGBA, w, h, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
  //      _ctx.texImage2D(gl.TEXTURE_CUBE_MAP_NEGATIVE_X, level, gl.RGBA, w, h, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
  //      _ctx.texImage2D(gl.TEXTURE_CUBE_MAP_POSITIVE_Y, level, gl.RGBA, w, h, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
  //      _ctx.texImage2D(gl.TEXTURE_CUBE_MAP_NEGATIVE_Y, level, gl.RGBA, w, h, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
  //      _ctx.texImage2D(gl.TEXTURE_CUBE_MAP_POSITIVE_Z, level, gl.RGBA, w, h, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
  //      _ctx.texImage2D(gl.TEXTURE_CUBE_MAP_NEGATIVE_Z, level, gl.RGBA, w, h, 0, gl.RGBA, gl.UNSIGNED_BYTE, null);
  //    }
  //  }
  //
  //  void uploadTexture2dData(gl.Texture texture, int width, int height, int level, data) {
  //    _ctx.bindTexture(gl.TEXTURE_2D, texture);
  //    _ctx.texImage2D(gl.TEXTURE_2D, level, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, data);
  //    _currentBoundTexture = texture;
  //  }
  //
  //  void uploadCubeTextureData(gl.Texture texture, int face, int width, int height, int level, data) {
  //    _ctx.bindTexture(gl.TEXTURE_CUBE_MAP, texture);
  //    _ctx.texImage2D(face, level, gl.RGBA, width, height, 0, gl.RGBA, gl.UNSIGNED_BYTE, data);
  //    _currentBoundTexture = texture;
  //  }
  //
  //  void deleteTexture(gl.Texture texture) {
  //    _textures.remove(texture);
  //    _ctx.deleteTexture(texture);
  //
  //    // TODO delete framebuffer
  //
  //    _textureSizes.remove(texture);
  //    _textureHasMipmaps.remove(texture);
  //    _textureTypes.remove(texture);
  //    _currentSamplers.remove(texture);
  //    for (var i = 0; i < _currentTexture.length; i++) {
  //      if (_currentTexture[i] == texture) {
  //        _currentTexture[i] = null;
  //      }
  //    }
  //    _currentBoundTexture = null;
  //  }
  //
  //  void setTextureAt(int position, gl.Texture texture, gl.UniformLocation location) {
  //    if (position > _currentTexture.length) return;
  //    var type = _textureTypes[texture];
  //    if (_currentTexture[position] != texture && _currentBoundTexture != texture) {
  //      _ctx.activeTexture(gl.TEXTURE0 + position);
  //      _ctx.bindTexture(type, texture);
  //      _currentTexture[position] = texture;
  //      _currentBoundTexture = texture;
  //    }
  //    _ctx.uniform1i(location, position);
  //  }










  setState(int cap, bool enable) {
    if (enable) {
      _ctx.enable(cap);
    } else {
      _ctx.disable(cap);
    }
  }

  bool _cullingState;
  bool _cullBackFaces = true;
  bool _depthMask = false;

  void setCullingState(bool val) {
    if (_cullingState != val) {
      if (val) {
        _ctx.cullFace(_cullBackFaces ? gl.BACK : gl.FRONT);
        _ctx.enable(gl.CULL_FACE);
      } else {
        _ctx.disable(gl.CULL_FACE);
      }
      _cullingState = val;
    }
  }

  void set alphaMode(int mode) {
    switch (mode) {
      case ALPHA_DISABLE:
        depthMask = true;
        _ctx.disable(gl.BLEND);
        break;
      case ALPHA_COMBINE:
        depthMask = false;
        _ctx.blendFuncSeparate(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA, gl.ONE, gl.ONE);
        _ctx.enable(gl.BLEND);
        break;
      case ALPHA_ADD:
        depthMask = false;
        _ctx.blendFuncSeparate(gl.ONE, gl.ONE, gl.ZERO, gl.ONE);
        _ctx.enable(gl.BLEND);
        break;
    }
  }

  void set depthMask(bool enable) {
    if (_depthMask != enable) {
      _ctx.depthMask(enable);
      _depthMask = enable;
    }
  }

  Pass _currentPass;
  Shader _currentShader;

  void use(Pass pass) {
    if (_currentPass != pass) {
      if (_currentShader != null) {
        _currentShader.attributes.forEach((n, a) {
          _ctx.disableVertexAttribArray(a.location);
        });
      }
      _currentPass = pass;
      _currentShader = pass.shader;
      pass.bind(this);
      var uniforms = _currentShader.uniforms;
      var samplers = _currentShader.samplers;
      for (var i = 0; i < samplers.length; i++) _ctx.uniform1i(uniforms[samplers[i]].location, i);
    }
  }

  ShaderProperty _uniform(String symbol) => _currentShader.uniforms[symbol];

  uniformList(String symbol, Float32List value) => _ctx.uniform1fv(_uniform(symbol).location, value);

  uniformVector3(String symbol, Vector3 value) => _ctx.uniform3fv(_uniform(symbol).location, value._elements);

  uniformMatrix4(String symbol, Matrix4 value) => _ctx.uniformMatrix4fv(_uniform(symbol).location, false, value._elements);

  uniformMatrix4List(String symbol, Float32List value) => _ctx.uniformMatrix4fv(_uniform(symbol).location, false, value);

  uniformMatrix3List(String symbol, Float32List value) => _ctx.uniformMatrix3fv(_uniform(symbol).location, false, value);

  uniformFloat(String symbol, num value) => _ctx.uniform1f(_uniform(symbol).location, value);

  uniformFloat2(String symbol, num x, num y) => _ctx.uniform2f(_uniform(symbol).location, x, y);

  uniformFloat3(String symbol, num x, num y, num z) => _ctx.uniform3f(_uniform(symbol).location, x, y, z);

  uniformFloat4(String symbol, num x, num y, num z, num w) => _ctx.uniform4f(_uniform(symbol).location, x, y, z, w);

  uniformBool(String symbol, bool value) => _ctx.uniform1i(_uniform(symbol).location, value ? 1 : 0);

  uniformInt(String symbol, int value) => _ctx.uniform1i(_uniform(symbol).location, value);

  uniformColor3(String symbol, Color color) => uniformFloat3(symbol, color.red, color.green, color.blue);

  uniformColor4(String symbol, Color color) => uniformFloat4(symbol, color.red, color.green, color.blue, color.alpha);

  bindTexture(String sampler, Texture texture) {
    if (!_currentShader.ready) return;
    var textureChannel = _currentShader.samplers.indexOf(sampler);
    if (textureChannel < 0) {
      print("WARN: texture $sampler not found in current shader");
      return;
    }
    _ctx.activeTexture(gl.TEXTURE0 + textureChannel);
    _ctx.bindTexture(texture.target, texture.texture);
  }

  unbindTexture(String sampler, Texture texture) {
    if (!_currentShader.ready) return;
    var textureChannel = _currentShader.samplers.indexOf(sampler);
    if (textureChannel < 0) return;
    _ctx.activeTexture(gl.TEXTURE0 + textureChannel);
    _ctx.bindTexture(texture.target, null);
  }
}














class DeviceCapabilities {
  final int maxTexturesImageUnits;
  final num maxTextureSize;
  final num maxCubemapTextureSize;
  final num maxRenderTextureSize;
  final bool standardDerivatives;
  final gl.CompressedTextureS3TC s3tc;
  final bool textureFloat;
  final gl.AngleInstancedArrays instancedArrays;
  gl.ExtTextureFilterAnisotropic textureAnisotropicFilterExtension;
  num maxAnisotropy;

  DeviceCapabilities(gl.RenderingContext ctx)
      : maxTexturesImageUnits = ctx.getParameter(gl.MAX_TEXTURE_IMAGE_UNITS),
        maxTextureSize = ctx.getParameter(gl.MAX_TEXTURE_SIZE),
        maxCubemapTextureSize = ctx.getParameter(gl.MAX_CUBE_MAP_TEXTURE_SIZE),
        maxRenderTextureSize = ctx.getParameter(gl.MAX_RENDERBUFFER_SIZE),
        standardDerivatives = (ctx.getExtension('OES_standard_derivatives') != null),
        s3tc = ctx.getExtension('WEBGL_compressed_texture_s3tc'),
        textureFloat = (ctx.getExtension('OES_texture_float') != null),
        textureAnisotropicFilterExtension = ctx.getExtension('EXT_texture_filter_anisotropic'),
        instancedArrays = ctx.getExtension('ANGLE_instanced_arrays') {

    if (textureAnisotropicFilterExtension == null) textureAnisotropicFilterExtension = ctx.getExtension('WEBKIT_EXT_texture_filter_anisotropic');

    if (textureAnisotropicFilterExtension == null) textureAnisotropicFilterExtension = ctx.getExtension('MOZ_EXT_texture_filter_anisotropic');

    if (textureAnisotropicFilterExtension == null) {
      maxAnisotropy = 0;
    } else {
      maxAnisotropy = ctx.getParameter(gl.ExtTextureFilterAnisotropic.MAX_TEXTURE_MAX_ANISOTROPY_EXT);
    }
  }
}














