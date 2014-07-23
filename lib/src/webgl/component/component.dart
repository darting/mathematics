part of mathematics;




abstract class Component implements Disposable {
  List<Node> _targets = [];
  List<Node> get targets => _targets;
  Node getTarget(int i) => _targets[i];
  
  void _initialize();

  void _targetAdded(Node target);
  void _targetRemoved(Node target);
  
  void _update();
}
