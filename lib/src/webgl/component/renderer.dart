part of mathematics;




class Renderer extends Component {

  Color backgroundColor;
  BoundingInfo _bounds;
  bool castShadows;
  bool enabled;
  bool visible;
  int lightmapIndex;
  Vector4 lightmapTilingOffset;

  Material get material => null;
  Material get sharedMaterial => null;
  List<Material> materials;
  List<Material> sharedMaterials;

  bool receiveShadows;

  Renderer({this.backgroundColor, Material material, this.sharedMaterials}) {
    if (backgroundColor == null) backgroundColor = Color.black();
    if (material == null && sharedMaterials == null) {
      sharedMaterials = [new BasicMaterial()];
    } else if (sharedMaterials == null) {
      sharedMaterials = [material];
    }
  }

  @override
  void _targetAdded(Node target) {
    if (target._renderer != null) throw new Exception("There cannot be two Renderer on the same node.");



  }

  @override
  void _targetRemoved(Node target) {
    // TODO: implement _targetRemoved
  }

  void render(GraphicsDevice graphics, [Texture renderTarget]) {

    // event
    // rendertarget
    
    assertNotNull(target, "target must be not null");
    assertNotNull(target.meshInstance, "mesh instance must be not null");
    assertNotNull(target.meshInstance.mesh, "mesh must be not null");

    
    var mesh = target.meshInstance.mesh;
    
    
    graphics.clear(backgroundColor.red, backgroundColor.green, backgroundColor.blue, backgroundColor.alpha);

    // TODO get draw calls from pool ?
    var material = sharedMaterials.first;
    
    if(material.ready(graphics, target)) {
      graphics.use(material.technique.defaultPass);
          
      material.bind(graphics, target);
      
      mesh._subMeshes.forEach((subMesh) {
        graphics.drawTriangles(subMesh._indices);
      });

      graphics.flush();
    }

    

    // event

  }
}







