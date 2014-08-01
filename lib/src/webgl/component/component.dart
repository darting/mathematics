part of mathematics;




abstract class Component implements Disposable {

  String id;

  Component([String id]) {
    this.id = id;
  }

  List<Entity> _entities = [];
  List<Entity> get entities => _entities;
  Entity getEntity(int i) => _entities[i];
  Entity get entity => _entities.first;

  bool _enabled = true;
  void set enabled(bool val) {
    _enabled = val;
    _enabledChanged();
  }
  bool get enabled => _enabled;
  void _enabledChanged() {}

  void update() {}

  void _receive(String message, data) {}

  void _entityAdded(Entity entity) {}
  void _entityRemoved(Entity entity) {}

  void dispose() {}
}
