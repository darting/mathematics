part of mathematics;




abstract class Node extends EventTrigger implements Disposable {
  final String uniqueId;
  Node root;
  Node parent;
  List<Node> _children;
  List<Node> get children => _children;

  Node(this.uniqueId);

  void addChild(Node child) {
    if (_children == null) _children = [];
    
    _children.add(child);
    child.removeFromParent();
    child.root = root == null ? this : root;
    child.parent = this;
    child.on("addToParent").dispatch(this);
    if(root is Scene) child.on("addToScene").dispatch(this);
  }

  void removeFromParent() {
    if (parent != null) {
      parent.removeChild(this);
    }
  }

  void removeChild(Node child) {
    if (child.parent != this || _children != null) return;

    _children.remove(child);
    _removeChild(child);
  }

  void removeChildren() {
    if (_children != null) {
      _children.forEach(_removeChild);
      _children.clear();
    }
  }

  void _removeChild(Node child) {
    child.root = null;
    child.parent = null;
    child.on("removeFromParent").dispatch(this);
    if (root is Scene) child.on("removeFromScene").dispatch(this);
  }

  bool contains(Node child) {
    if (_children != null) return _children.contains(child);
    return false;
  }

  void updateRoot(Node root) {
    this.root = root;
    if (_children != null) {
      _children.forEach((c) => c.updateRoot(root));
    }
  }

  @override
  void dispose() {
    cancelSubscriptions();
  }
  
  @override
  String toString() => uniqueId;
}
