part of mathematics;





class Entity extends EventTrigger implements Disposable {

  final String uniqueId;
  final List<Component> components;

  Entity parent;
  List<Entity> _children;
  List<Entity> get children => _children;

  Renderer _renderer;
  Renderer get renderer => _renderer;

  MeshInstance _meshInstance;
  MeshInstance get meshInstance => _meshInstance;

  Transform _transform;
  Transform get transform => _transform;
  
  Camera _camera;
  Camera get camera => _camera;

  Entity(this.uniqueId) : components = [];

  void addChild(Entity child) {
    if (_children == null) _children = [];
    _children.add(child);
    child.removeFromParent();
    child.parent = this;
  }

  void removeFromParent() {
    if (parent != null) parent.removeChild(this);
  }

  void removeChild(Entity child) {
    if (child.parent == this) child.parent = null;
    if (_children != null) _children.remove(child);
  }

  void removeChildren() {
    if (_children != null) {
      _children.forEach((c) => c.parent = null);
      _children.clear();
    }
  }

  bool contains(Entity child) {
    if (_children != null) return _children.contains(child);
    return false;
  }

  void addComponent(Component component) {
    _setSpecialComponent(component, component);
    components.add(component);
    component._entities.add(this);
    component._entityAdded(this);
  }

  void removeComponent(Component component) {
    if(!components.contains(component))
      throw new Exception("This component is not belong the node");
    _setSpecialComponent(component, null);
    components.remove(component);
    component._entities.remove(this);
    component._entityRemoved(this);
  }

  void _setSpecialComponent(Component component, value) {
    if (component is Renderer) {
      _renderer = value;
    } else if (component is MeshInstance) {
      _meshInstance = value;
    } else if (component is Transform) {
      _transform = value;
    } else if (component is Camera) {
      _camera = value;
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

  @override
  void dispose() {
    cancelSubscriptions();
  }
}
