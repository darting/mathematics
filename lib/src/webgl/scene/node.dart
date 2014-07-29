part of mathematics;





class Node extends EventTrigger implements Disposable {

  final String uniqueId;
  final List<Component> components;

  Node parent;
  List<Node> _children;

  Renderer _renderer;
  Renderer get renderer => _renderer;

  MeshInstance _meshInstance;
  MeshInstance get meshInstance => _meshInstance;

  Transform _transform;
  Transform get transform => _transform;

  Node(this.uniqueId) : components = [];

  void addChild(Node child) {
    if (_children == null) _children = [];
    _children.add(child);
    child.removeFromParent();
    child.parent = this;
  }

  void removeFromParent() {
    if (parent != null) parent.removeChild(this);
  }

  void removeChild(Node child) {
    if (child.parent == this) child.parent = null;
    if (_children != null) _children.remove(child);
  }

  void removeChildren() {
    if (_children != null) {
      _children.forEach((c) => c.parent = null);
      _children.clear();
    }
  }

  bool contains(Node child) {
    if (_children != null) return _children.contains(child);
    return false;
  }

  void addComponent(Component component) {
    _setSpecialComponent(component, component);
    components.add(component);
    component._targetAdded(this);
  }

  void removeComponent(Component component) {
    _setSpecialComponent(component, null);
    components.remove(component);
    component._targetRemoved(this);
  }

  void _setSpecialComponent(Component component, value) {
    if (component is Renderer) {
      _renderer = value;
    } else if (component is MeshInstance) {
      _meshInstance = value;
    } else if (component is Transform) {
      _transform = value;
    }
  }

  Component findComponent(Type t) => components.firstWhere((c) => c.runtimeType == t);

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
