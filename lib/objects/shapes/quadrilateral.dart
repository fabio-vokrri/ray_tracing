import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/objects/materials/material.dart';
import 'package:ray_tracing/utility/aabb.dart';
import 'package:ray_tracing/utility/hit_record.dart';
import 'package:ray_tracing/utility/hittable.dart';
import 'package:ray_tracing/utility/interval.dart';

class Quadrilateral extends Hittable {
  final Point3 _q;
  final Vector3 _u, _v;
  final Material _material;

  late AABB _bbox;
  late Vector3 _normal, _w;
  late double _d;

  Quadrilateral({
    required Point3 q,
    required Vector3 u,
    required Vector3 v,
    required Material material,
  })  : _q = q,
        _u = u,
        _v = v,
        _material = material //
  {
    Vector3 n = _u.cross(_v);
    _normal = n.normalized;
    _d = _normal.dot(_q);
    _w = n / (n.dot(n));
    _bbox = AABB.fromPoints(_q, _q + _u + _v).pad();
  }

  @override
  AABB get boundingBox => _bbox;

  @override
  (bool, HitRecord?) hit(Ray ray, Interval rayT, HitRecord? hitRecord) {
    double denom = _normal.dot(ray.direction);
    if (denom.abs() < 1e-8) {
      // theray is parallel to the plane
      return (false, null);
    }

    double t = (_d - _normal.dot(ray.origin)) / denom;
    if (!rayT.contains(t)) {
      return (false, null);
    }

    Vector3 intersection = ray.at(t);
    Vector3 planarHitPointVector = intersection - _q;
    double alpha = _w.dot(planarHitPointVector.cross(_v));
    double beta = _w.dot(_u.cross(planarHitPointVector));

    if (alpha < 0 || alpha > 1 || beta < 0 || beta > 1) {
      return (false, null);
    }

    HitRecord record = HitRecord(
      point: intersection,
      normal: _normal,
      material: _material,
      t: t,
      u: alpha,
      v: beta,
    )..setNormalFace(ray, _normal);

    return (true, record);
  }
}
