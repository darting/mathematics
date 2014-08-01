part of mathematics;




class Assets {

  Map<String, Mesh> _meshes = {};
  Map<String, Texture> _textures = {};

  void addMesh(Mesh mesh) {
    if (_meshes.containsKey(mesh.id)) throw new Exception("${mesh.id} must be unique id");
    _meshes[mesh.id] = mesh;
  }

  Mesh getMesh(String id) => _meshes[id];

  Texture getTexture(String id) => _textures[id];

  Texture loadTexture(String url, {String id, int target: gl.TEXTURE_2D, int type: gl.UNSIGNED_BYTE, int format: gl.RGBA, Sampler sampler, bool usesMipMaps: false, bool flip: false}) {

    if (_textures.containsKey(url)) return _textures[url];

    var ctx = Engine._sharedInstance._graphics._ctx;
    var texture = new Texture._(or(id, url));
    texture.source = url;
    texture.target = target;
    texture.type = type;
    texture.format = format;
    texture.sampler = or(sampler, Sampler.defaultSampler);
    texture.flip = flip;
    texture.mipMapping = usesMipMaps;
    var image = new html.ImageElement(src: url);
    image.onLoad.listen((_) {
      texture.texture = ctx.createTexture();
      var sampler = texture.sampler;
      texture.width = image.width;
      texture.height = image.height;
      if (usesMipMaps || sampler.wrapS == gl.REPEAT || sampler.wrapT == gl.REPEAT) {
        image = _ensureImage(image);
      }
      ctx.bindTexture(texture.target, texture.texture);
      if (texture.flip) {
        ctx.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, 1);
      } else {
        ctx.pixelStorei(gl.UNPACK_FLIP_Y_WEBGL, 0);
      }
      ctx.texParameteri(texture.target, gl.TEXTURE_WRAP_S, sampler.wrapS);
      ctx.texParameteri(texture.target, gl.TEXTURE_WRAP_T, sampler.wrapT);
      ctx.texParameteri(texture.target, gl.TEXTURE_MIN_FILTER, sampler.minFilter);
      ctx.texParameteri(texture.target, gl.TEXTURE_MAG_FILTER, sampler.magFilter);
      ctx.texImage2D(texture.target, 0, texture.format, texture.format, texture.type, image);
      if (usesMipMaps) {
        ctx.generateMipmap(texture.target);
      }
      ctx.bindTexture(texture.target, null);
      texture._ready = true;
      _textures[texture.id] = texture;
    });
    return texture;
  }

  static _ensureImage(html.ImageElement source) {
    var img = source;
    var shouldResize = false;
    var width = source.width;
    if (!_isPowerOfTwo(width)) {
      width = _nextHighestPowerOfTwo(width);
      shouldResize = true;
    }
    var height = source.height;
    if (!_isPowerOfTwo(height)) {
      height = _nextHighestPowerOfTwo(height);
      shouldResize = true;
    }
    if (shouldResize) {
      var canvas = new html.CanvasElement();
      canvas.width = width;
      canvas.height = height;
      var graphics = canvas.context2D;
      graphics.drawImageScaled(source, 0, 0, width, height);
      img = canvas;
    }
    return img;
  }

  static bool _isPowerOfTwo(int x) {
    return (x & (x - 1)) == 0;
  }

  static int _nextHighestPowerOfTwo(int x) {
    --x;
    for (var i = 1; i < 32; i <<= 1) {
      x = x | x >> i;
    }
    return x + 1;
  }
}
