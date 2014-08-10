import 'dart:html' as html;
import 'dart:math' as math;
import 'package:mathematics/mathematics.dart';


void main() {
  var canvas = html.querySelector("#stage");
  var engine = new Engine(canvas);
  var scene = engine.scene;
  var assets = engine.assets;

  assets.addMesh(new CubeMesh("cube"));
  assets.addMesh(new PlaneMesh("plane", width: 5.0, height: 5.0, ground: false));
  assets.addMesh(new SphereMesh("sphere", radius: 0.6));
  assets.addMesh(new SphereMesh("light", radius: 0.05));
  assets.loadTexture("res/obj/skin.jpg", id: "skin");
  assets.loadTexture("res/images/crate.png", id: "crate");

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
    ..addComponent(new Surface(material: material2));
    head2.transform.translate(0.0, -1.0);
    scene.addChild(head2);
  });

  var m = new PhongMaterial();
  m.diffuseTexture = assets.getTexture("skin");

  var cube = new GameObject("cube");
  cube
    ..addComponent(new Transform())
    ..addComponent(new MeshInstance(assets.getMesh("cube")))
    ..addComponent(new Surface(material: new PhongMaterial()..diffuseTexture = assets.getTexture("crate")));
  cube.transform.translate(0.0, -1.0, 0.0);
  scene.addChild(cube);

  var plane = new GameObject("plane");
  plane
    ..addComponent(new Transform())
    ..addComponent(new MeshInstance(assets.getMesh("plane")))
    ..addComponent(new Surface(material: m));
  plane.transform.translate(0.0, -1.0, 0.0);
  plane.transform.rotateX(-math.PI / 2);
  scene.addChild(plane);

  var camera = new GameObject("camera");
  camera
    ..addComponent(new Transform())
    ..addComponent(new PerspectiveCamera(canvas.clientWidth / canvas.clientHeight));
  camera.transform.translate(0.0, 0.0, 5.0);
  camera.camera.lookAt(new Vector3.zero());
  scene.addChild(camera);

  var lightColor0 = new Color(1.0, 1.0, 1.0);
  var light0 = new GameObject("light0");
  light0
    ..addComponent(new Transform())
    ..addComponent(new MeshInstance(assets.getMesh("light")))
    ..addComponent(new Surface(material: new BasicMaterial(lightColor0)))
    ..addComponent(new PointLight()..diffuseColor=lightColor0..intensity=0.2);
  light0.transform.translate(-1.0, 1.0, 1.0);
  scene.addChild(light0);

  var lightColor1 = new Color(1.0, 1.0, 1.0);
  var light1 = new GameObject("light1");
  light1
    ..addComponent(new Transform())
    ..addComponent(new MeshInstance(assets.getMesh("light")))
    ..addComponent(new Surface(material: new BasicMaterial(lightColor1)))
    ..addComponent(new SpotLight()..diffuseColor = lightColor1..specularColor = new Color(1.0, 1.0, 0.0));
  light1.transform.translate(1.0, 1.0, 1.0);
  light1.transform.rotateY(math.PI / 4);
  light1.transform.rotateZ(math.PI / 3);
  scene.addChild(light1);

  var speed = 1000;
  var i = 2;

  engine.enterFrame = () {
//    camera.transform.setTranslation(math.cos(engine.totalTime / speed) * 5.0, 0.0, math.sin(engine.totalTime / speed) * 5.0);
//    camera.camera.lookAt(new Vector3.zero());
    light0.transform.setTranslation(math.cos(engine.totalTime / speed) * 2.0, 1.0, math.sin(engine.totalTime / speed) * 2.0);
    light1.transform.rotateY(engine.elapsedTime * 0.001);
//    sphere.transform.rotateY(0.01);
//    var cos = math.cos(engine.totalTime / speed) * 2.0;
//    var sin = math.sin(engine.totalTime / speed) * 2.0;
//    light1.transform.setTranslation(sin, cos, 0.0);
  };
  engine.run();
}
