import 'dart:math';

import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/utility/interval.dart';

class AABB {
  final Interval x, y, z;

  /// Creates a new Axis Aligned Bounding Box.
  AABB({
    this.x = const Interval.empty(),
    this.y = const Interval.empty(),
    this.z = const Interval.empty(),
  });

  /// Creates a new Axis Aligned Bounding Box from the given points.
  AABB.fromPoints(Point3 a, Point3 b)
      : x = Interval(min(a.x, b.x), max(a.x, b.x)),
        y = Interval(min(a.y, b.y), max(a.y, b.y)),
        z = Interval(min(a.z, b.z), max(a.z, b.z));

  /// Creates a new Axis Aligned Bounding Box from the given boxes.
  AABB.fromBoxes(AABB box1, AABB box2)
      : x = Interval.fromIntervals(box1.x, box2.x),
        y = Interval.fromIntervals(box1.y, box2.y),
        z = Interval.fromIntervals(box1.z, box2.z);

  /// Returns the `i`-th axis' interval of this aabb.
  ///
  /// Throws Argument error if `i` is out of range.
  Interval operator [](int i) {
    if (i < 0 || i > 3) {
      throw ArgumentError.value(i, null, "Index out of bounds");
    }

    if (i == 0) return x;
    if (i == 1) return y;
    return z;
  }

  bool hit(Ray ray, Interval rayT) {
    for (int i = 0; i < 3; i++) {
      double t0 = min(
        (this[i].min - ray.origin[i]) / ray.direction[i],
        (this[i].max - ray.origin[i]) / ray.direction[i],
      );

      double t1 = max(
        (this[i].min - ray.origin[i]) / ray.direction[i],
        (this[i].max - ray.origin[i]) / ray.direction[i],
      );

      rayT = rayT.copyWith(min: max(t0, rayT.min), max: min(t1, rayT.max));

      if (rayT.max <= rayT.min) {
        return false;
      }
    }
    return true;
  }
}
