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
  assets.addMesh(new SphereMesh("light", radius: 0.05));
  assets.loadTexture("res/obj/skin.jpg", id: "skin");
  
  var simpleMaterial = new BasicMaterial();
  
  new ObjLoader().load("res/obj/head.o", "head").then((m) {
    
    assets.addMesh(m);
    
//    var material = new PhysicallyBasedRenderMaterial();
//    material.diffuseTexture = assets.getTexture("skin");
//    
//    var head = new GameObject("head")
//      ..addComponent(new Transform())
//      ..addComponent(new MeshInstance(m))
//      ..addComponent(new Renderer(material: material));
//    head.transform.translate(0.5, -1.0);
//    scene.addChild(head);
    
    var material2 = new PhongMaterial();
    material2.diffuseTexture = assets.getTexture("skin");
    var head2 = new GameObject("head2")
    ..addComponent(new Transform())
    ..addComponent(new MeshInstance(m))
    ..addComponent(new Renderer(material: material2));
    head2.transform.translate(0.0, -1.0);
    //scene.addChild(head2);
  });
  
  var m = new PhongMaterial();
  m.diffuseTexture = assets.getTexture("skin");
  
  var sphere = new GameObject("sphere");
  sphere
  ..addComponent(new Transform())
  ..addComponent(new MeshInstance(assets.getMesh("sphere")))
  ..addComponent(new Renderer(material: m));
  scene.addChild(sphere);

  var camera = new GameObject("camera");
  camera
      ..addComponent(new Transform())
      ..addComponent(new PerspectiveCamera(canvas.clientWidth / canvas.clientHeight));
  camera.transform.translate(0.0, 1.0, 5.0);
  camera.camera.lookAt(new Vector3.zero());
  scene.addChild(camera);

  var lightColor0 = new Color(1.0, 0.0, 0.0);
  var light0 = new GameObject("light0");
  light0
  ..addComponent(new Transform())
  ..addComponent(new MeshInstance(assets.getMesh("light")))
  ..addComponent(new Renderer(material: new BasicMaterial(lightColor0)))
  ..addComponent(new DirectionalLight()..diffuseColor=new Color.fromHex(0xff0000));
  light0.transform.translate(0.0, 0.0, 1.0);
  //scene.addChild(light0);
  
  var lightColor1 = new Color(1.0, 1.0, 1.0);
  var light1 = new GameObject("light1");
  light1
    ..addComponent(new Transform())
    ..addComponent(new MeshInstance(assets.getMesh("light")))
    ..addComponent(new Renderer(material: new BasicMaterial(lightColor1)))
    ..addComponent(new DirectionalLight()..diffuseColor = lightColor1..specularColor = new Color(1.0, 1.0, 0.0));
  //light1.transform.rotateY(math.PI / 4);
  scene.addChild(light1);

  var speed = 5000;
  var i = 2;
  
  engine.enterFrame = () {
//    camera.transform.translate(math.cos(engine.totalTime / speed) * 5.0, 1.0, math.sin(engine.totalTime / speed) * 5.0);
//    camera.camera.lookAt(new Vector3.zero());
    light1.transform.rotateY(engine.elapsedTime * 0.001);
  };

  engine.run();
}
