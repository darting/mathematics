import 'dart:html' as html;
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
  camera.transform.translate(0.0, 1.0, 5.0);
  camera.transform.rotateY(1.07);
  root.addChild(camera);
  
  var cube = new Node("cube");
  cube
      ..addComponent(new Transform())
      ..addComponent(new MeshInstance(assets.getMesh("cube")))
      ..addComponent(new Renderer());
  root.addChild(cube);
  

  engine.enterFrame = () {
    
  };

  engine.run();
}
