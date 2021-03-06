part of mathematics;




abstract class Material {

  Technique technique;

  /**
   * refer: http://docs.unity3d.com/Manual/SL-SubshaderTags.html
   * there are five pre-defined queues in [RenderQueue]
   * using to determine in which order your objects are drawn
   */
  int renderQueue;
  
  bool ready(GraphicsDevice graphics, Surface surface);
  
  void bind(GraphicsDevice graphics, Camera camera, GameObject entity);
  
}



class RenderQueue {
  static const int BACKGROUND = 1000;
  static const int GEOMETRY = 2000;
  static const int ALPHATEST = 2450;
  static const int TRANSPARENT = 3000;
  static const int OVERLAY = 4000;
}
