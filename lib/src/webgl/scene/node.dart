part of mathematics;





class Node extends EventTrigger {

  void addChild(Node child) {
    html.CanvasElement el;
    el.onClick;
  }

  void removeChild(Node child) {

  }

  void removeChildren() {

  }

  bool contains(Node child) {

  }
  
  Renderer _renderer;
  Renderer get renderer => _renderer;

  void addComponent(Component component) {
    if(component is Renderer) _renderer = component;
    
    // TODO
    component._targetAdded(this);
  }

  void removeComponent(Component component) {
    if(component is Renderer) _renderer = null;
    
    component._targetRemoved(this);
  }

  bool hasComponent(Component component) {

  }

  void updateRoot() {

  }

}
