part of mathematics;




class SceneManager {

  final List<Node> roots = [];

  List<Renderer> _renderables = [];

  void add(Node root) {
    roots.add(root);
  }

  void _updateNode(Node node) {
    node.components.forEach((c) {
      c.update();
      if (c is Renderer) _renderables.add(c);
    });
    if (node._children != null) node._children.forEach(_updateNode);
  }

  void update() {
    _renderables.clear();

    roots.forEach(_updateNode);

    var graphics = Engine._sharedInstance._graphics;

    var renderTargets = Camera.getRenderTargets();
    renderTargets.forEach((camera) {
      _renderables.forEach((r) {
        r.render(graphics, camera);
      });
    });

    if(renderTargets.length > 0) graphics.restoreDefaultFramebuffer();
    
    var camera = Camera.main;
    _renderables.forEach((r) {
      r.render(graphics, camera);
    });

  }
}
