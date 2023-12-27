import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/objects/materials/material.dart';

/// HitRecord type: represents the information generated from the impact
/// of a ray into an object of the scene.
class HitRecord {
  Point3 point;
  Vector3 normal;
  Material material;
  double t;
  double u, v;
  bool isFrontFace;

  /// creates a new hitRecord.
  HitRecord({
    required this.point,
    required this.normal,
    required this.material,
    required this.t,
    this.u = 0,
    this.v = 0,
    this.isFrontFace = false,
  });

  /// Sets the hit record normal face to `outwardNormal` based on the `ray` direction.
  ///
  /// `outwardNormal` must have unit length.
  void setNormalFace(Ray ray, Vector3 outwardNormal) {
    isFrontFace = ray.direction.dot(outwardNormal) < 0;
    normal = isFrontFace ? outwardNormal : -outwardNormal;
  }
}
