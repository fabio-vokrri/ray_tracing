import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/vector.dart';

abstract class Texture {
  Color value(double u, double v, Point3 point);
}
