part of mathematics;




class Program implements Disposable {

  GraphicsDevice _graphics;
  gl.Program _program;
  gl.Shader _vertexShader;
  gl.Shader _fragmentShader;
  Map<String, ShaderProperty> _attributes;
  Map<String, ShaderProperty> _uniforms;
  List<String> _sampers;
  bool _ready = false;

  Program(this._graphics, String vertSrc, String fragSrc, {String common: ""}) {
    _initialize(vertSrc, fragSrc, common: common);
  }

  /**
   * vertex source file:   ${url}VS.glsl
   * fragment source file: ${url}FS.glsl
   **/
  Program.load(String url) {
    Future.wait([html.HttpRequest.getString("${url}VS.glsl"), html.HttpRequest.getString("${url}FS.glsl")]).then((r) =>
        _initialize(r[0], r[1]));
  }

  _initialize(String vertSrc, String fragSrc, {String common: ""}) {
    var ctx = _graphics._ctx;
    _vertexShader = _compileShader(ctx, "$common\n$vertSrc", gl.VERTEX_SHADER);
    _fragmentShader = _compileShader(ctx, "$common\n$fragSrc", gl.FRAGMENT_SHADER);
    _program = ctx.createProgram();
    ctx.attachShader(_program, _vertexShader);
    ctx.attachShader(_program, _fragmentShader);
    ctx.linkProgram(_program);
    if (!ctx.getProgramParameter(_program, gl.LINK_STATUS)) {
      dispose();
    } else {
      _attributes = {};
      var attribCount = ctx.getProgramParameter(_program, gl.ACTIVE_ATTRIBUTES);
      for (var i = 0; i < attribCount; i++) {
        var info = ctx.getActiveAttrib(_program, i);
        _attributes[info.name] = new ShaderProperty(info.name, ctx.getAttribLocation(_program, info.name), info.type);
      }

      _uniforms = {};
      _sampers = [];
      var uniformCount = ctx.getProgramParameter(_program, gl.ACTIVE_UNIFORMS);
      for (var i = 0; i < uniformCount; i++) {
        var uniform = ctx.getActiveUniform(_program, i);
        var name = uniform.name;
        var ii = name.indexOf("[0]");
        if (ii != -1) {
          name = name.substring(0, ii);
        }
        _uniforms[name] = new ShaderProperty(name, ctx.getUniformLocation(_program, name), uniform.type);
        if (uniform.type == gl.SAMPLER_2D || uniform.type == gl.SAMPLER_CUBE) {
          _sampers.add(name);
        }
      }
      _ready = true;
    }
  }

  gl.Shader _compileShader(gl.RenderingContext ctx, String source, int type) {
    var shader = ctx.createShader(type);
    ctx.shaderSource(shader, source);
    ctx.compileShader(shader);
    var s = ctx.getShaderParameter(shader, gl.COMPILE_STATUS);
    if (ctx.getShaderParameter(shader, gl.COMPILE_STATUS) == false) {
      print(ctx.getShaderInfoLog(shader));
      ctx.deleteShader(shader);
      return null;
    }
    return shader;
  }

  @override
  void dispose() {
    if (_program != null) {
      _graphics._ctx.deleteProgram(_program);
      _graphics._ctx.deleteShader(_vertexShader);
      _graphics._ctx.deleteShader(_fragmentShader);
    }
  }
}


class ShaderProperty {
  String name;
  dynamic location;
  int type;
  ShaderProperty(this.name, this.location, this.type);
}
