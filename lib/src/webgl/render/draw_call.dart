part of mathematics;



/**
 * refer: http://docs.unity3d.com/Manual/DrawCallBatching.html
 * 
 * for better rendering performance, we can combine a number of objects
 * at runtime and draws them together with a single draw call.
 * 
 * 1. only objects sharing the same material can be batched together.
 * 2. if two materials only differ in textures, we can combine those textures into a single big texture
 *    called texture atlasing.
 * 
 * 3. dynamic batching have vertex limit.
 * 
 * 4. static batching
 *    static objects can not move, rotate and scale in the game.
 *    static batching will require additional memory for storing the combined geometry.
 *    if sereval objects shared the same geometry before static batching. then a copy of geometry will be created
 *    for each object.
 */
class DrawCall {

  void configure(Shader program) {

  }

  void bind() {
    reset();
    _bindIndexBuffer();
    _bindProgram();
    _bindStates();
    _sort();
  }

  void _bindIndexBuffer() {

  }

  void _bindProgram() {
  }

  void _bindStates() {
  }

  void _sort() {
  }

  void reset() {
  }

}



































