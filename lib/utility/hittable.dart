import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/utility/aabb.dart';
import 'package:ray_tracing/utility/hit_record.dart';
import 'package:ray_tracing/utility/interval.dart';

/// Hittable type: represents any type of object that can be hit by a ray.
abstract class Hittable {
  (bool didHit, HitRecord? hitRecord) hit(
    Ray ray,
    Interval rayT,
    HitRecord? hitRecord,
  );

  AABB get boundingBox;
}
