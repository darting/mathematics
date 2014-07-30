import 'dart:html' as html;
import 'dart:math' as math;
import 'package:mathematics/mathematics.dart';


void main() {
  var canvas = html.querySelector("#stage");
  var engine = new Engine(canvas);
  var sceneManager = engine.sceneManager;
  var assets = engine.assets;

  assets.addMesh(new CubeMesh("cube"));

  
  var root = new Node("root");
  sceneManager.add(root);

  var camera = new Node("camera");
  camera
      ..addComponent(new Transform())
      ..addComponent(new PerspectiveCamera(canvas.clientWidth / canvas.clientHeight));
  camera.transform.translate(5.0, 1.0, 5.0);
  camera.camera.lookAt(new Vector3.zero());
  
  root.addChild(camera);
  
  var cube = new Node("cube");
  cube
      ..addComponent(new Transform())
      ..addComponent(new MeshInstance(assets.getMesh("cube")))
      ..addComponent(new Renderer(backgroundColor: Color.black()));
  root.addChild(cube);

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
