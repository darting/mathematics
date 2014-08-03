library mathematics;
import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:math' as math;
import 'dart:web_gl' as gl;
import 'dart:async';



//part 'src/linear_algebra/vector3.dart';



part 'src/webgl/disposable.dart';

part 'src/webgl/engine.dart';
part 'src/webgl/assets.dart';
part 'src/webgl/mesh.dart';

part 'src/webgl/loader/obj_loader.dart';

part 'src/webgl/component/component.dart';
part 'src/webgl/component/camera.dart';
part 'src/webgl/component/renderer.dart';
part 'src/webgl/component/transform.dart';
part 'src/webgl/component/perspective_camera.dart';
part 'src/webgl/component/mesh_instance.dart';
part 'src/webgl/component/light.dart';

part 'src/webgl/scene/node.dart';
part 'src/webgl/scene/game_object.dart';
part 'src/webgl/scene/scene.dart';

part 'src/webgl/primitives/cube.dart';
part 'src/webgl/primitives/sphere.dart';

part 'src/webgl/geometry/geometry.dart';

part 'src/webgl/material/material.dart';
part 'src/webgl/material/basic_material.dart';
part 'src/webgl/material/phong_material.dart';
part 'src/webgl/material/physically_based_render_material.dart';

part 'src/webgl/math/matrix4.dart';
part 'src/webgl/math/quaternion.dart';
part 'src/webgl/math/vector2.dart';
part 'src/webgl/math/vector3.dart';
part 'src/webgl/math/vector4.dart';
part 'src/webgl/math/color.dart';
part 'src/webgl/math/ray.dart';
part 'src/webgl/math/bounding_info.dart';

part 'src/webgl/texture/texture.dart';
part 'src/webgl/texture/render_target_texture.dart';
part 'src/webgl/texture/sampler.dart';

part 'src/webgl/render/graphics_device.dart';
part 'src/webgl/render/resource.dart';
part 'src/webgl/render/shader.dart';
part 'src/webgl/render/technique.dart';
part 'src/webgl/render/pass.dart';
part 'src/webgl/render/vertex_buffer.dart';
part 'src/webgl/render/draw_call.dart';
part 'src/webgl/render/draw_call_pool.dart';

// not finish yet
part 'src/webgl/render/draw_call_backup.dart';

part 'src/webgl/event/event_stream.dart';
part 'src/webgl/event/event_trigger.dart';




typedef void Callback();
typedef void Callback1<T>();
typedef void Callback2<T1, T2>();



final Vector3 WORLD_LEFT = new Vector3(1.0, 0.0, 0.0);
final Vector3 WORLD_UP = new Vector3(0.0, 1.0, 0.0);
final Vector3 WORLD_FRONT = new Vector3(0.0, 0.0, 1.0);



void assertNotNull(target, String desc) {
  if(target == null) throw new Exception(desc);
}

or(expectValue, defaultValue) {
  if (expectValue == null) return defaultValue;
  return expectValue;
}






















