part of mathematics;




class Texture {
  gl.Texture texture;
  int width;
  int height;
  bool mipMapping = false;
  
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
}