part of mathematics;




class Texture {
  
  gl.Texture texture;
  String id;
  int width;
  int height;
  bool mipMapping = false;
  bool flip = false;
  String source;
  
  /**
   * gl.TEXTURE_2D or gl.TEXTURE_CUBE_MAP 
   */
  int target;
  
  /**
   * gl.RGBA 
   */
  int format;
  
  int type = gl.UNSIGNED_BYTE;
  
  Sampler sampler = Sampler.defaultSampler;
  
  Texture._(this.id);
  
  bool _ready = false;
  bool get ready => _ready;
}