part of mathematics;




abstract class Component implements Disposable {

  String id;

  Component([String id]) {
    this.id = id;
  }

  List<GameObject> _entities = [];
  List<GameObject> get entities => _entities;
  GameObject getEntity(int i) => _entities[i];
  GameObject get entity {
    if (_entities.length == 0) return null;
    return _entities.first;
  }

  bool _enabled = true;
  void set enabled(bool val) {
    _enabled = val;
    _enabledChanged();
  }
  bool get enabled => _enabled;
  void _enabledChanged() {}

  void update() {}

  void _receive(String message, data) {}

  void _entityAdded(GameObject entity) {}
  void _entityRemoved(GameObject entity) {}

  void _addedToScene(Scene scene) {}
  void _removedFromScene() {}
  
  void dispose() {}
}
