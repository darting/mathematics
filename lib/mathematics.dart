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

part 'src/webgl/component/component.dart';
part 'src/webgl/component/camera.dart';
part 'src/webgl/component/renderer.dart';
part 'src/webgl/component/transform.dart';
part 'src/webgl/scene_manager.dart';
part 'src/webgl/component/perspective_camera.dart';
part 'src/webgl/component/mesh_filter.dart';

part 'src/webgl/scene/node.dart';

part 'src/webgl/geometry/geometry.dart';

part 'src/webgl/material/material.dart';

part 'src/webgl/math/matrix4.dart';
part 'src/webgl/math/quaternion.dart';
part 'src/webgl/math/vector3.dart';
part 'src/webgl/math/vector4.dart';
part 'src/webgl/math/color.dart';
part 'src/webgl/math/ray.dart';
part 'src/webgl/math/bounding_info.dart';

part 'src/webgl/texture/texture.dart';
part 'src/webgl/texture/sampler.dart';

part 'src/webgl/render/graphics_device.dart';
part 'src/webgl/render/resource.dart';
part 'src/webgl/render/program.dart';
part 'src/webgl/render/vertex_buffer.dart';
part 'src/webgl/render/draw_call.dart';

part 'src/webgl/event/event_stream.dart';
part 'src/webgl/event/event_trigger.dart';


typedef void Callback();
typedef void Callback1<T>();
typedef void Callback2<T1, T2>();