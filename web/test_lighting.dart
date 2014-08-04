import 'dart:html' as html;
import 'dart:math' as math;
import 'package:mathematics/mathematics.dart';


void main() {
  var canvas = html.querySelector("#stage");
  var engine = new Engine(canvas);
  var scene = engine.scene;
  var assets = engine.assets;

  assets.addMesh(new CubeMesh("cube"));
  assets.addMesh(new SphereMesh("sphere", radius: 0.6));
  assets.loadTexture("res/obj/skin.jpg", id: "skin");
  
  new ObjLoader().load("res/obj/head.o", "head").then((m) {
    
    assets.addMesh(m);
    
    var material = new PhysicallyBasedRenderMaterial();
    material.diffuseTexture = assets.getTexture("skin");
    
    var head = new GameObject("head")
      ..addComponent(new Transform())
      ..addComponent(new MeshInstance(m))
      ..addComponent(new Renderer(material: material));
    head.transform.translate(0.5, -1.0);
    scene.addChild(head);
    
    var material2 = new PhongMaterial();
    material2.diffuseTexture = assets.getTexture("skin");
    var head2 = new GameObject("head2")
    ..addComponent(new Transform())
    ..addComponent(new MeshInstance(m))
    ..addComponent(new Renderer(material: material2));
    head2.transform.translate(-1.0, -1.0);
    scene.addChild(head2);
  });

  var camera = new GameObject("camera");
  camera
      ..addComponent(new Transform())
      ..addComponent(new PerspectiveCamera(canvas.clientWidth / canvas.clientHeight));
  camera.transform.translate(0.0, 1.0, 5.0);
  camera.camera.lookAt(new Vector3.zero());
  scene.addChild(camera);

  var light0 = new GameObject("light0");
  light0
  ..addComponent(new DirectionalLight());

  var speed = 1000;
  var i = 2;
  
  engine.enterFrame = () {
//    camera.transform.translate(math.cos(engine.totalTime / speed) * 5.0, 1.0, math.sin(engine.totalTime / speed) * 5.0);
//    camera.camera.lookAt(new Vector3.zero());
  };

  engine.run();
}
