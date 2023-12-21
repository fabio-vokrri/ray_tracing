import 'package:ray_tracing/main.dart';
import 'package:ray_tracing/utility/color.dart';
import 'package:ray_tracing/utility/vector.dart';

/// Ray type: represents a ray in space.
class Ray {
  final Point3 _origin;
  final Vector3 _direction;

  const Ray({
    required Vector3 origin,
    required Vector3 direction,
  })  : _origin = origin,
        _direction = direction;

  /// Returns the origin point of this ray.
  Point3 get origin => _origin;

  /// Returns the direction vector of this ray.
  Vector3 get direction => _direction;

  /// Returns the point along this ray at distance `t` from the origin.
  Point3 at(double t) {
    return origin + direction * t;
  }

  /// Returns the color of this ray.
  Color get color {
    // if this ray hits the sphere, returns a blue-ish color
    if (hitSphere(Point3(0, 0, -1), 0.5, this)) {
      return Color.fromHex(0xFF780000);
    }

    // calculates the sky color gradient
    Vector3 unitDirection = _direction.normalized;
    double a = 0.5 * (unitDirection.y + 1);

    return Color.white() * (1 - a) + Color.fromHex(0xFF8ECAE6) * a;
  }
}
