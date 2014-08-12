/**
 * Copyright (C) 2014 Valor Zhong
 * http://valorzhong.blogspot.com
 */

part of mathematics;




class Behavior extends Component {
  Callback callback;

  Behavior(this.callback);

  void update() {
    callback();
  }

}

class Billboard extends Component {

  Camera facing;

  Billboard([this.facing]);

  @override
  void update() {
    if(entity != null && entity.root is Scene && entity.transform != null) {
      var camera = facing == null ? entity.scene.mainCamera : facing;
      entity.transform.lookAt(-camera.entity.transform.worldPosition);
    }
  }


}