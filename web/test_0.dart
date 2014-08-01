import 'dart:html' as html;
import 'dart:math' as math;
import 'package:mathematics/mathematics.dart';


void main() {
  var canvas = html.querySelector("#stage");
  var engine = new Engine(canvas);
  var scene = engine.scene;
  var assets = engine.assets;

  assets.addMesh(new CubeMesh("cube"));

  var camera = new GameObject("camera");
  camera
      ..addComponent(new Transform())
      ..addComponent(new PerspectiveCamera(canvas.clientWidth / canvas.clientHeight));
  camera.transform.translate(5.0, 1.0, 5.0);
  camera.camera.lookAt(new Vector3.zero());
  
  scene.addChild(camera);
  
  var cube = new GameObject("cube");
  cube
      ..addComponent(new Transform())
      ..addComponent(new MeshInstance(assets.getMesh("cube")))
      ..addComponent(new Renderer());
  scene.addChild(cube);
  
  var cube2 = new GameObject("cube")
      ..addComponent(new Transform())
      ..addComponent(new MeshInstance(assets.getMesh("cube")))
      ..addComponent(new Renderer());
  cube2.transform.translate(-1.5);
  scene.addChild(cube2);

  var speed = 1000;
  var i = 2;
  
  engine.enterFrame = () {
    camera.transform.translate(math.cos(engine.totalTime / speed) * 5.0, 1.0, math.sin(engine.totalTime / speed) * 5.0);
//    print(camera.transform.position);
    camera.camera.lookAt(new Vector3.zero());
//    camera.findComponent(PerspectiveCamera).lookAt(new Vector3.zero());
  };

  engine.run();
}
