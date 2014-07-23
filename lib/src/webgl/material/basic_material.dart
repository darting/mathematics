part of mathematics;




class BasicMaterial extends Material {
  BasicMaterial({Color color, Texture diffuse, Vector2 offset, Vector2 scale}) {
    this.color = color;
    this.diffuseTexture = diffuse;
    this.diffuseOffset = offset;
    this.diffuseScale = scale;
    technique = new Technique();
    technique.add(new Pass("default", new Shader.load("webgl/shaders/basic")));
  }
  
  bool ready(GraphicsDevice graphics, Node target) {
    return true;
  }

  @override
  void bind(GraphicsDevice graphics, Node target) {
    // TODO: implement bind
  }
}
