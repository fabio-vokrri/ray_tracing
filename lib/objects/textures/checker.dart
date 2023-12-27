import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/objects/textures/solid_color.dart';
import 'package:ray_tracing/objects/textures/texture.dart';

class Checker extends Texture {
  final double _inverseScale;
  final Texture _evenTexture;
  final Texture _oddTexture;

  Checker({
    required double scale,
    required Texture evenTexture,
    required Texture oddTexture,
  })  : _inverseScale = 1 / scale,
        _evenTexture = evenTexture,
        _oddTexture = oddTexture;

  Checker.fromColors(double scale, Color color1, Color color2)
      : _inverseScale = 1 / scale,
        _evenTexture = SolidColor(color1),
        _oddTexture = SolidColor(color2);

  @override
  Color value(double u, double v, Point3 point) {
    int x = (point.x * _inverseScale).floor();
    int y = (point.y * _inverseScale).floor();
    int z = (point.z * _inverseScale).floor();

    bool isEven = (x + y + z) % 2 == 0;
    return isEven
        ? _evenTexture.value(u, v, point)
        : _oddTexture.value(u, v, point);
  }
}
