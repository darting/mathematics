part of mathematics;




abstract class Component {
  List<Node> _targets = [];
  List<Node> get targets => _targets;
  Node getTarget(int i) => _targets[i];

  void _targetAdded(Node target);
  void _targetRemoved(Node target);
}
