part of mathematics;




class DrawCallPool {

  Map<String, DrawCall> _drawCalls = {};

  void register(Surface renderer) {
    var entity = renderer.entity;
    var key = identity(entity);
    var drawCall = _drawCalls[key];
    if (drawCall == null) {
      drawCall = new DrawCall(renderer);
      _drawCalls[key] = drawCall;
    }
    drawCall.combine(renderer.entity);
  }

  void unregister(Surface renderer) {
    var key = identity(renderer.entity);
    var drawCall = _drawCalls[key];
    if (drawCall != null) {
      drawCall.separate(renderer.entity);
      _drawCalls.remove(key);
    }
  }

  String identity(GameObject entity) {
    return entity.surface.hashCode.toString();
//    var material = entity.renderer.sharedMaterial;
//    return entity.isStatic ? material.hashCode.toString() : "${material.hashCode}_${entity.hashCode}";
  }
  
  void render(GraphicsDevice graphics, Camera camera) {
    _drawCalls.forEach((_, drawCall) {
      drawCall.render(graphics, camera);
    });
    graphics.flush();
  }
}














