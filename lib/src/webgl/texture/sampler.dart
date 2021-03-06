part of mathematics;




class Sampler {
  static final Sampler defaultSampler = new Sampler();
  
  int _magFilter = gl.LINEAR;
  int _minFilter = gl.LINEAR;
  int _wrapS = gl.REPEAT;
  int _wrapT = gl.REPEAT;
  
  set magFilter(int val) => _magFilter = val == null ? gl.LINEAR : val; 
  int get magFilter => _magFilter;
  
  set minFilter(int val) => _minFilter = val == null ? gl.LINEAR : val;
  int get minFilter => _minFilter;
  
  set wrapS(int val) => _wrapS = val == null ? gl.REPEAT : val;
  int get wrapS => _wrapS;
  
  set wrapT(int val) => _wrapT = val == null ? gl.REPEAT : val;
  int get wrapT => _wrapT;
}