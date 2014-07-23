part of mathematics;




class Pass {
  String name;
  bool depthTest = true;
  bool depthMask = true;
  bool cullFaceEnable = true;
  bool blending = false;

  int alphaMode = 1;
  
  int blendEquation = gl.FUNC_ADD;
  int sfactor = gl.SRC_ALPHA;
  int dfactor = gl.ONE_MINUS_SRC_ALPHA;

  int modeRGB = gl.FUNC_ADD;
  int modeAlpha = gl.FUNC_ADD;
  int srcRGB = gl.SRC_ALPHA;
  int dstRGB = gl.ONE_MINUS_SRC_ALPHA;
  int srcAlpha = gl.ONE;
  int dstAlpha = gl.ONE;

  Shader shader;

  Pass(this.name, [this.shader]);

  void bind(GraphicsDevice graphics) {
    var ctx = graphics._ctx;
    shader.prepare(graphics);
    ctx.useProgram(shader._program);
    graphics.setState(gl.DEPTH_TEST, depthTest);
    graphics.cullingState = cullFaceEnable;
    graphics.setState(gl.SAMPLE_ALPHA_TO_COVERAGE, true);
    graphics.setState(gl.BLEND, blending);
    if (blending) {
      if (alphaMode == 0) {
        ctx.blendEquation(blendEquation);
        ctx.blendFunc(sfactor, dfactor);
      } else {
        ctx.blendEquationSeparate(modeRGB, modeAlpha);
        ctx.blendFuncSeparate(srcRGB, dstRGB, srcAlpha, dstAlpha);
      }
    }
    ctx.depthMask(depthMask);
  }

  dispose() {
    if (shader != null) shader.dispose();
  }
}
