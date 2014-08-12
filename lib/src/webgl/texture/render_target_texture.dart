part of mathematics;




class RenderTargetTexture extends Texture implements Renderer {
  
  gl.Renderbuffer depthBuffer;
  gl.Framebuffer framebuffer;
  
  bool generateDepthBuffer = true;
  
  RenderTargetTexture(String id) : super._(id);

  void prepare(GraphicsDevice graphics) {
    
    if(_ready) return;
    
    var ctx = graphics._ctx;
    target = gl.TEXTURE_2D;
    format = gl.RGBA;

    texture = ctx.createTexture();
    ctx.activeTexture(gl.TEXTURE0);
    ctx.bindTexture(target, texture);
    ctx.texParameteri(target, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
    ctx.texParameteri(target, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
    ctx.texParameteri(target, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
    ctx.texParameteri(target, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
    if (graphics.caps.textureFloat) {
      ctx.texImage2DTyped(target, 0, format, width, height, 0, format, gl.FLOAT, null);
    } else {
      ctx.texImage2DTyped(target, 0, format, width, height, 0, format, gl.UNSIGNED_BYTE, null);
    }

    // renderbuffer
    if (generateDepthBuffer) {
      depthBuffer = ctx.createRenderbuffer();
      ctx.bindRenderbuffer(gl.RENDERBUFFER, depthBuffer);
      ctx.renderbufferStorage(gl.RENDERBUFFER, gl.DEPTH_COMPONENT16, width, height);
    }

    // framebuffer
    framebuffer = ctx.createFramebuffer();
    ctx.bindFramebuffer(gl.FRAMEBUFFER, framebuffer);
    ctx.framebufferTexture2D(gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, target, texture, 0);

    ctx.bindFramebuffer(gl.FRAMEBUFFER, null);
    ctx.bindRenderbuffer(gl.RENDERBUFFER, null);
    ctx.bindTexture(target, null);
    
    _ready = true;
  }

  @override
  void render(GraphicsDevice graphics, Camera camera, Scene scene) {

  }

}
