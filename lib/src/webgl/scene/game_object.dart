part of mathematics;





class GameObject extends Node {

  final List<Component> components;

  bool isStatic = false;

  Surface _surface;
  Surface get surface => _surface;

  MeshInstance _meshInstance;
  MeshInstance get meshInstance => _meshInstance;

  Transform _transform;
  Transform get transform => _transform;

  Camera _camera;
  Camera get camera => _camera;

  Light _light;
  Light get light => _light;

  Scene get scene => root as Scene;

  GameObject(String uniqueId)
      : components = [],
        super(uniqueId);
  
  @override
  void _addedToScene() {
    super._addedToScene();
    components.forEach((c) => c._addedToScene(scene));
  }
  
  @override
  void _removedFromScene() {
    super._removedFromScene();
    components.forEach((c) => c._removedFromScene());
  }

  void addComponent(Component component) {
    _setSpecialComponent(component, component);
    components.add(component);
    component._entities.add(this);
    component._entityAdded(this);
  }

  void removeComponent(Component component) {
    if (!components.contains(component)) throw new Exception("This component is not belong the node");
    _setSpecialComponent(component, null);
    components.remove(component);
    component._entities.remove(this);
    component._entityRemoved(this);
  }

  void _setSpecialComponent(Component component, value) {
    if (component is Surface) {
      _surface = value;
    } else if (component is MeshInstance) {
      _meshInstance = value;
    } else if (component is Transform) {
      _transform = value;
    } else if (component is Camera) {
      _camera = value;
    } else if (component is Light) {
      _light = value;
    }
  }

  Component findComponent(Type t) => components.firstWhere((c) => c.runtimeType == t, orElse: () => null);

  bool hasComponent(Component component) => components.contains(component);

  /**
   * notifies all attached components with a message and data
   */
  void notify(String message, data) {
    components.forEach((c) => c._receive(message, data));
  }
}
