import 'dart:math';

import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/utility/hit_record.dart';

/// Sphere type: represents a sphere in space
class Sphere extends Hittable {
  final Point3 _center;
  final double _radius;

  Sphere({
    required Point3 center,
    required double radius,
  })  : _center = center,
        _radius = radius;

  /// Returns wether or not the given `ray` did hit this sphere.
  @override
  (bool, HitRecord?) hit(
    Ray ray,
    double rayTmin,
    double rayTmax,
    HitRecord? hitRecord,
  ) {
    Vector3 oc = ray.origin - _center;
    double a = ray.direction.squaredLength;
    double halfB = oc.dot(ray.direction);
    double c = oc.squaredLength - _radius * _radius;

    double discriminant = halfB * halfB - a * c;
    if (discriminant < 0) return (false, null);
    double sqrtDiscriminant = sqrt(discriminant);

    // Finds the nearest root that lies in the acceptable range
    double root = (-halfB - sqrtDiscriminant) / a;
    if (root <= rayTmin || root >= rayTmax) {
      root = (-halfB + sqrtDiscriminant) / a;
      if (root <= rayTmin || root >= rayTmax) {
        return (false, null);
      }
    }
    // creates a new hit record because the ray did hit the sphere
    Vector3 outwardNormal = (ray.at(root) - _center) / _radius;
    HitRecord hitRecord = HitRecord(
      point: ray.at(root),
      normal: outwardNormal,
      t: root,
    );
    hitRecord.setNormalFace(ray, outwardNormal);

    return (true, hitRecord);
  }
}