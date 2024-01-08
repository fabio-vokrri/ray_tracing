import 'dart:math';

import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/objects/textures/texture.dart';
import 'package:ray_tracing/utility/perlin.dart';

class Noise extends Texture {
  final Perlin _noise = Perlin();
  final double _scale;

  Noise({double scale = 1}) : _scale = scale;

  @override
  Color value(double u, double v, Point3 point) {
    Point3 scaled = point * _scale;
    return Color.fromRGB(127, 127, 127) *
        (1 + sin(scaled.z + 10 * _noise.turbolence(scaled)));
  }
}
