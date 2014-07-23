part of mathematics;




abstract class Component implements Disposable {

  String id;

  List<Node> _targets = [];
  List<Node> get targets => _targets;
  Node getTarget(int i) => _targets[i];
  Node get target => _targets.first;

  void _initialize() {}

  bool _enable = true;
  void set enable(bool val) {
    _enable = val;
    _enabledChanged();
  }
  void _enabledChanged() {}

  void update() {}

  void _receive(String message, data) {}

  void _targetAdded(Node target) {}
  void _targetRemoved(Node target) {}
  
  void dispose() {}
}
