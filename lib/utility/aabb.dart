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

  /// Returns a new AABB that has no side narrower than 0.0001,
  /// expanding the required side.
  AABB pad() {
    double delta = 0.0001;
    Interval newX = x.size >= delta ? x : x.expand(delta);
    Interval newY = y.size >= delta ? y : y.expand(delta);
    Interval newZ = z.size >= delta ? z : z.expand(delta);

    return AABB(x: newX, y: newY, z: newZ);
  }

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

  /// Adds the given offset to this bounding box.
  AABB operator +(Vector3 offset) {
    return AABB(x: x + offset.x, y: y + offset.y, z: z + offset.z);
  }

  bool hit(Ray ray, Interval rayT) {
    for (int axis = 0; axis < 3; axis++) {
      double inverseDirection = 1 / ray.direction[axis];
      double origin = ray.origin[axis];

      double t0 = (this[axis].min - origin) * inverseDirection;
      double t1 = (this[axis].max - origin) * inverseDirection;

      if (inverseDirection < 0) [t0, t1] = [t1, t0];
      if (t0 > rayT.min) rayT = rayT.copyWith(min: t0);
      if (t1 < rayT.max) rayT = rayT.copyWith(max: t1);

      if (rayT.max <= rayT.min) return false;
    }

    return true;
  }

}
