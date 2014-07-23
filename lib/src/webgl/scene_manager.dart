part of mathematics;




class SceneManager {

  final List<Node> roots = [];

  List<Renderer> _renderables = [];

  void add(Node root) {
    roots.add(root);
  }

  void update() {
    _renderables.clear();

    roots.forEach((node) {
      node.components.forEach((c) {
        c.update();
        if (c is Renderer) _renderables.add(c);
      });
    });

    var graphics = Engine._sharedInstance._graphics;

    _renderables.forEach((r) {
      r.render(graphics);
    });
  }
}
