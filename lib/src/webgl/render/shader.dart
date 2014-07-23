part of mathematics;




/**
 * shaders contain code that defines what kind of properties and assets to use.
 */
class Shader implements Disposable {

  GraphicsDevice _graphics;
  gl.Program _program;
  gl.Shader _vertexShader;
  gl.Shader _fragmentShader;
  Map<String, ShaderProperty> _attributes;
  Map<String, ShaderProperty> _uniforms;
  List<String> _samplers;
  bool _ready = false;
  bool get ready => _ready;
  
  String _vertSrc, _fragSrc, _commonSrc;

  Shader(this._graphics, this._vertSrc, this._fragSrc, {String common: ""}) {
    _commonSrc = common;
  }

  /**
   * vertex source file:   [url]VS.glsl
   * fragment source file: [url]FS.glsl
   **/
  Shader.load(String url, {String common: ""}) {
    Future.wait([html.HttpRequest.getString("${url}VS.glsl"), 
                 html.HttpRequest.getString("${url}FS.glsl")]).then((r) {
      _vertSrc = r[0];
      _commonSrc = r[1];
      _commonSrc = common;
    });
  }
  
  void prepare(GraphicsDevice graphics) {
    if(_ready) return;
    _compile(graphics, _vertSrc, _fragSrc, common: _commonSrc);
    // I don't wanna store the source again
    _vertSrc = null;
    _fragSrc = null;
    _commonSrc = null;
  }

  _compile(GraphicsDevice graphics, String vertSrc, String fragSrc, {String common: ""}) {
    if(vertSrc == null || fragSrc == null) return;
    
    var ctx = graphics._ctx;

    _vertexShader = _compileShader(ctx, "$common\n$vertSrc", gl.VERTEX_SHADER);
    if (_vertexShader == null) return;

    _fragmentShader = _compileShader(ctx, "$common\n$fragSrc", gl.FRAGMENT_SHADER);
    if (_fragmentShader == null) return;

    _program = ctx.createProgram();
    ctx.attachShader(_program, _vertexShader);
    ctx.attachShader(_program, _fragmentShader);
    ctx.linkProgram(_program);
    if (!ctx.getProgramParameter(_program, gl.LINK_STATUS)) {
      dispose();
      return;
    }

    _attributes = {};
    var attribCount = ctx.getProgramParameter(_program, gl.ACTIVE_ATTRIBUTES);
    for (var i = 0; i < attribCount; i++) {
      var info = ctx.getActiveAttrib(_program, i);
      _attributes[info.name] = new ShaderProperty(info.name, ctx.getAttribLocation(_program, info.name), info.type);
    }

    _uniforms = {};
    _samplers = [];
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
        _samplers.add(name);
      }
    }
    _ready = true;
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
      var ctx = Engine._sharedInstance._graphics._ctx;
      ctx.deleteProgram(_program);
      ctx.deleteShader(_vertexShader);
      ctx.deleteShader(_fragmentShader);
    }
  }
}


class ShaderProperty {
  String name;
  dynamic location;
  int type;
  ShaderProperty(this.name, this.location, this.type);
}
