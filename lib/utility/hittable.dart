import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/utility/hit_record.dart';
import 'package:ray_tracing/utility/interval.dart';

/// Hittable type: represents any type of object that can be hit by a ray.
abstract class Hittable {
  /// If the
  (bool didHit, HitRecord? hitRecord) hit(
    Ray ray,
    Interval rayT,
    HitRecord? hitRecord,
  );
}
