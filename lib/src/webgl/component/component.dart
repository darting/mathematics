part of mathematics;




abstract class Component implements Disposable {

  String id;

  Component([String id]) {
    this.id = id;
  }

  List<Node> _targets = [];
  List<Node> get targets => _targets;
  Node getTarget(int i) => _targets[i];
  Node get target => _targets.first;

  bool _enabled = true;
  void set enabled(bool val) {
    _enabled = val;
    _enabledChanged();
  }
  bool get enabled => _enabled;
  void _enabledChanged() {}

  void update() {}

  void _receive(String message, data) {}

  void _targetAdded(Node target) {}
  void _targetRemoved(Node target) {}

  void dispose() {}
}
