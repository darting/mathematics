import 'dart:html' as html;
import 'dart:math' as math;
import 'package:mathematics/mathematics.dart';


void main() {
  var canvas = html.querySelector("#stage");
  var engine = new Engine(canvas);
  var scene = engine.scene;
  var assets = engine.assets;

  assets.addMesh(new CubeMesh("cube"));
  assets.loadTexture("res/obj/skin.jpg", id: "skin");
  
  new ObjLoader().load("res/obj/head.o", "head").then((m) {
    
    var material = new PhysicallyBasedRenderMaterial();
    material.diffuseTexture = assets.getTexture("skin");
    
    var head = new GameObject("head")
      ..addComponent(new Transform())
      ..addComponent(new MeshInstance(m))
      ..addComponent(new Renderer(material: material));
    head.transform.translate(0.0, -1.0);
    scene.addChild(head);
  });

  var camera = new GameObject("camera");
  camera
      ..addComponent(new Transform())
      ..addComponent(new PerspectiveCamera(canvas.clientWidth / canvas.clientHeight));
  camera.transform.translate(5.0, 1.0, 5.0);
  camera.camera.lookAt(new Vector3.zero());
  scene.addChild(camera);
  
  var cube = new GameObject("cube")
      ..addComponent(new Transform())
      ..addComponent(new MeshInstance(assets.getMesh("cube")))
      ..addComponent(new Renderer());
  cube.transform.translate(-1.5);
  scene.addChild(cube);

  var speed = 1000;
  var i = 2;
  
  engine.enterFrame = () {
    camera.transform.translate(math.cos(engine.totalTime / speed) * 5.0, 1.0, math.sin(engine.totalTime / speed) * 5.0);
    camera.camera.lookAt(new Vector3.zero());
  };

  engine.run();
}
