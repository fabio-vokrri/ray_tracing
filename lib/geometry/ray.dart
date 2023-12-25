import 'package:ray_tracing/geometry/vector.dart';

/// Ray type: represents a ray in space.
class Ray {
  final Point3 _origin;
  final Vector3 _direction;
  final double _time;

  /// Creates a new ray that starts at `origin` in the given `direction`.
  const Ray({
    required Point3 origin,
    required Vector3 direction,
    double time = 0,
  })  : _origin = origin,
        _direction = direction,
        _time = time;

  /// Returns the origin point of this ray.
  Point3 get origin => _origin;

  /// Returns the direction vector of this ray.
  Vector3 get direction => _direction;

  /// Returns at which point in time this ray is.
  double get time => _time;

  /// Returns the point along this ray at distance `t` from the origin.
  Point3 at(double t) {
    return origin + direction * t;
  }
}
