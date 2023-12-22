import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/geometry/vector.dart';

abstract class Hittable {
  (bool didHit, HitRecord? hitRecord) hit(
    Ray ray,
    double rayTmin,
    double rayTmax,
    HitRecord? hitRecord,
  );
}

class HitRecord {
  Point3 point;
  Vector3 normal;
  double t;
  bool isFrontFace;

  HitRecord({
    required this.point,
    required this.normal,
    required this.t,
    this.isFrontFace = false,
  });

  /// Sets the hit record normal face.
  ///
  /// `outwardNormal` must have unit length.
  void setNormalFace(Ray ray, Vector3 outwardNormal) {
    isFrontFace = ray.direction.dot(outwardNormal) < 0;
    normal = isFrontFace ? outwardNormal : -outwardNormal;
  }
}
