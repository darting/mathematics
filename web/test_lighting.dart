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
  
//  new ObjLoader().load("res/obj/head.o", "head").then((m) {
//    
//    assets.addMesh(m);
//    
////    var material = new PhysicallyBasedRenderMaterial();
////    material.diffuseTexture = assets.getTexture("skin");
////    
////    var head = new GameObject("head")
////      ..addComponent(new Transform())
////      ..addComponent(new MeshInstance(m))
////      ..addComponent(new Renderer(material: material));
////    head.transform.translate(0.5, -1.0);
////    scene.addChild(head);
//    
//    var material2 = new PhongMaterial();
//    material2.diffuseTexture = assets.getTexture("skin");
//    var head2 = new GameObject("head2")
//    ..addComponent(new Transform())
//    ..addComponent(new MeshInstance(m))
//    ..addComponent(new Renderer(material: material2));
//    head2.transform.translate(-1.0, -1.0);
//    scene.addChild(head2);
//  });

  var camera = new GameObject("camera");
  camera
      ..addComponent(new Transform())
      ..addComponent(new PerspectiveCamera(canvas.clientWidth / canvas.clientHeight));
  camera.transform.translate(0.0, 1.0, 6.0);
  camera.camera.lookAt(new Vector3.zero());
  scene.addChild(camera);
  

  
  
  
  var m = new PhongMaterial();
  m.diffuseTexture = assets.getTexture("skin");

  var cube = new GameObject("cube");
  cube
    ..addComponent(new Transform())
    ..addComponent(new MeshInstance(assets.getMesh("cube")))
    ..addComponent(new Renderer(material: new PhongMaterial()..diffuseTexture = assets.getTexture("crate")));
  cube.transform.translate(0.0, -1.0, 0.0);
  scene.addChild(cube);
  
  var sphere = new GameObject("sphere");
  sphere
  ..addComponent(new Transform())
  ..addComponent(new MeshInstance(assets.getMesh("sphere")))
  ..addComponent(new Renderer(material: new PhongMaterial()..ambientColor=new Color(0.3, 0.3, 0.3)));
  sphere.transform.rotateY(math.PI/2);
  scene.addChild(sphere);

  var plane = new GameObject("plane");
  plane
    ..addComponent(new Transform())
    ..addComponent(new MeshInstance(assets.getMesh("plane")))
    ..addComponent(new Renderer(material: m));
  plane.transform.translate(0.0, -1.5, 0.0);
  plane.transform.rotateX(-math.PI / 2);
  scene.addChild(plane);

  var lightColor0 = new Color(0.0, 1.0, 0.0);
  var light0 = new GameObject("light0");
  light0
    ..addComponent(new Transform())
    ..addComponent(new MeshInstance(assets.getMesh("light")))
    ..addComponent(new Renderer(material: new BasicMaterial(lightColor0)))
    ..addComponent(new PointLight()..diffuseColor=lightColor0..specularColor=lightColor0..intensity=1.0);
  light0.transform.translate(-1.0, 1.0, 1.0);
  scene.addChild(light0);

  var lightColor1 = new Color(1.0, 1.0, 1.0);
  var light1 = new GameObject("light1");
  light1
    ..addComponent(new Transform())
    ..addComponent(new MeshInstance(assets.getMesh("light")))
    ..addComponent(new Renderer(material: new BasicMaterial(lightColor1)))
    ..addComponent(new SpotLight()..diffuseColor = lightColor1..specularColor = lightColor1..intensity=1.0);
  light1.transform.translate(1.0, 1.0, 2.0);
  light1.transform.rotateY(math.PI / 4);
  light1.transform.rotateZ(math.PI / 3);
  //scene.addChild(light1);
  
  var lightColor2 = new Color(1.0, 0.0, 0.0);
  var light2 = new GameObject("light2");
  light2
    ..addComponent(new Transform())
    ..addComponent(new MeshInstance(assets.getMesh("light")))
    ..addComponent(new Renderer(material: new BasicMaterial(lightColor2)))
    ..addComponent(new PointLight()..diffuseColor=lightColor2..specularColor=lightColor2..intensity=1.0);
  light2.transform.translate(1.0, 1.0, 1.0);
  scene.addChild(light2);
  
  var lightColor3 = new Color(0.0, 0.0, 1.0);
  var light3 = new GameObject("light3");
  light3
    ..addComponent(new Transform())
    ..addComponent(new MeshInstance(assets.getMesh("light")))
    ..addComponent(new Renderer(material: new BasicMaterial(lightColor3)))
    ..addComponent(new PointLight()..diffuseColor=lightColor3..specularColor=lightColor3..intensity=1.0);
  light3.transform.translate(0.0, 1.0, 1.0);
  scene.addChild(light3);
  
  
  

  var speed = 1000;
  var dist = 1.5;
  
  engine.enterFrame = () {
//    camera.transform.translate(math.cos(engine.totalTime / speed) * 5.0, 1.0, math.sin(engine.totalTime / speed) * 5.0);
//    camera.camera.lookAt(new Vector3.zero());
    
    light0.transform.setTranslation(math.cos(engine.totalTime / speed) * dist, 
          0.0, 
          math.sin(engine.totalTime / speed) * dist);
    
    light2.transform.setTranslation(math.sin(engine.totalTime / speed) * dist, 
            0.0, 
            math.cos(engine.totalTime / speed) * dist);
    
    light3.transform.setTranslation(math.sin(engine.totalTime / speed) * dist, 
            math.cos(engine.totalTime / speed) * dist,
            math.sin(engine.totalTime / speed) * dist);
    
  };

  engine.run();
}
