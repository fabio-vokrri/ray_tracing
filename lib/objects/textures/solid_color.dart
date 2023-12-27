import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/objects/textures/texture.dart';

class SolidColor extends Texture {
  final Color _color;

  SolidColor(Color color) : _color = color;

  @override
  Color value(double u, double v, Point3 point) {
    return _color;
  }
}
