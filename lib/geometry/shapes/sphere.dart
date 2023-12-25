import 'dart:math';

import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/materials/material.dart';
import 'package:ray_tracing/utility/aabb.dart';
import 'package:ray_tracing/utility/hit_record.dart';
import 'package:ray_tracing/utility/hittable.dart';
import 'package:ray_tracing/utility/interval.dart';

/// Sphere type: represents a sphere in space.
class Sphere extends Hittable {
  final Point3 _center;
  final bool _isMoving;
  final double _radius;
  final Material _material;
  late final AABB _boundingBox;
  late final Vector3? _centerDirection;

  /// Creates a new stationary sphere centered in `center` with the given `radius`.
  Sphere({
    required Point3 center,
    required double radius,
    required Material material,
  })  : _center = center,
        _radius = radius,
        _material = material,
        _isMoving = false,
        _centerDirection = null //
  {
    Vector3 radiusVector = Vector3(radius, radius, radius);
    _boundingBox = AABB.fromPoints(
      _center - radiusVector,
      _center + radiusVector,
    );
  }

  /// Creates a new moving sphere centered in `center` with the given `radius`.
  Sphere.moving({
    required Point3 center1,
    required Point3 center2,
    required double radius,
    required Material material,
  })  : _center = center1,
        _radius = radius,
        _material = material,
        _isMoving = true,
        _centerDirection = center2 - center1 //
  {
    Vector3 radiusVector = Vector3(radius, radius, radius);
    AABB box1 = AABB.fromPoints(center1 - radiusVector, center1 + radiusVector);
    AABB box2 = AABB.fromPoints(center2 - radiusVector, center2 + radiusVector);
    _boundingBox = AABB.fromBoxes(box1, box2);
  }

  /// Returns wether or not the given `ray` did hit this sphere.
  ///
  /// If `ray` did hit the sphere at the given `rayT` interval returns a new HitRecord,
  /// containing information about the hit.
  @override
  (bool, HitRecord?) hit(
    Ray ray,
    Interval rayT,
    HitRecord? hitRecord,
  ) {
    Point3 center = _getCenterAt(ray.time);
    Vector3 oc = ray.origin - center;
    double a = ray.direction.squaredLength;
    double halfB = oc.dot(ray.direction);
    double c = oc.squaredLength - _radius * _radius;

    double discriminant = halfB * halfB - a * c;
    if (discriminant < 0) return (false, null);
    double sqrtDiscriminant = sqrt(discriminant);

    // Finds the nearest root that lies in the acceptable range
    double root = (-halfB - sqrtDiscriminant) / a;
    if (!rayT.surrounds(root)) {
      root = (-halfB + sqrtDiscriminant) / a;
      if (!rayT.surrounds(root)) {
        return (false, null);
      }
    }

    // creates a new hit record because the ray did hit the sphere
    Vector3 outwardNormal = (ray.at(root) - center) / _radius;
    hitRecord = HitRecord(
      point: ray.at(root),
      normal: outwardNormal,
      material: _material,
      t: root,
    )..setNormalFace(ray, outwardNormal);

    return (true, hitRecord);
  }

  /// Returns the center of this sphere at the given `time`.
  Point3 _getCenterAt(double time) {
    // Linearly interpolates from center1 to center2 according to time,
    // where t=0 yields center1, and t=1 yields center2.
    // Only if _isMoving flag is set to true
    if (_isMoving) {
      return _center + _centerDirection! * time;
      //               ^ if the sphere is moving, _centerDirection is not null
    }

    return _center;
  }

  /// Returns the bounding box of this sphere.
  @override
  AABB get boundingBox => _boundingBox;
}
