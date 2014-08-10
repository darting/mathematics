part of mathematics;




class Surface extends Component {

  BoundingInfo _bounds;
  bool castShadows;
  bool enabled;
  bool visible;
  int lightmapIndex;
  Vector4 lightmapTilingOffset;

  double visibility = 1.0;
  
  //Material get material => null;
  Material get sharedMaterial => sharedMaterials.first;
  //List<Material> materials;
  List<Material> sharedMaterials;

  bool receiveShadows;

  Surface({Material material, this.sharedMaterials}) {
    if (material == null && sharedMaterials == null) {
      sharedMaterials = [new BasicMaterial()];
    } else if (sharedMaterials == null) {
      sharedMaterials = [material];
    }
  }

  @override
  void _entityAdded(GameObject entity) {

  }

  @override
  void _entityRemoved(GameObject entity) {
    _cleanup();
  }
  
  @override 
  void _addedToScene(Scene scene) {
    entity.scene._registerRenderer(this);
  }
  
  @override
  void _removedFromScene() {
    _cleanup();
  }

  void dispose() {
    _cleanup();
  }

  void _cleanup() {
    Engine._sharedInstance.scene._unregisterRenderer(this);
  }
}




