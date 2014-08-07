part of mathematics;




class Renderer extends Component {

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

  StreamSubscription _addToScene;
  StreamSubscription _removeFromScene;

  Renderer({Material material, this.sharedMaterials}) {
    if (material == null && sharedMaterials == null) {
      sharedMaterials = [new BasicMaterial()];
    } else if (sharedMaterials == null) {
      sharedMaterials = [material];
    }
  }

  @override
  void _entityAdded(GameObject entity) {
    _addToScene = entity.on("addToScene").listen((_) {
      entity.scene._registerRenderer(this);
    });
    _removeFromScene = entity.on("removeFromScene").listen((_) {
      _cleanup();
    });
  }

  @override
  void _entityRemoved(GameObject entity) {
    _cleanup();
  }

  void dispose() {
    _cleanup();
  }

  void _cleanup() {
    if (_addToScene != null) _addToScene.cancel();
    if (_removeFromScene != null) _removeFromScene.cancel();
    Engine._sharedInstance.scene._unregisterRenderer(this);
  }
}




