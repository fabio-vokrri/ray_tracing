import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/shapes/sphere.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/utility/hit_record.dart';

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
    Sphere sphere = Sphere(center: Point3(0, 0, -1), radius: 0.5);
    var (bool didHit, HitRecord? hitRecord) =
        sphere.hit(this, 0, double.infinity, null);
    if (didHit) {
      Vector3 n = (at(hitRecord!.t) - Vector3(0, 0, -1)).normalized;
      return Color.fromDecimal(n.x + 1, n.y + 1, n.z + 1) * 0.5;
    }

    // calculates the sky color gradient
    Vector3 unitDirection = _direction.normalized;
    double a = 0.5 * (unitDirection.y + 1);

    return Color.white() * (1 - a) + Color.fromHex(0xFF8ECAE6) * a;
  }
}
