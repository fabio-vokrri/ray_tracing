import 'dart:math';

import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/utility/aabb.dart';
import 'package:ray_tracing/utility/hit_record.dart';
import 'package:ray_tracing/utility/hittable.dart';
import 'package:ray_tracing/utility/interval.dart';
import 'package:ray_tracing/utility/scene.dart';

class BVHNode extends Hittable {
  late Hittable _left;
  late Hittable _right;
  late AABB _boundingBox;

  BVHNode(List<Hittable> objects, int start, int end) {
    int axis = Random().nextInt(3);
    var comparator = axis == 0
        ? _compareBoxX
        : axis == 1
            ? _compareBoxY
            : _compareBoxZ;

    int span = end - start;
    if (span == 1) {
      _left = _right = objects[start];
    } else if (span == 2) {
      if (comparator(objects[start], objects[start + 1]) < 0) {
        _left = objects[start];
        _right = objects[start + 1];
      } else {
        _left = objects[start + 1];
        _right = objects[start];
      }
    } else {
      objects.sort(comparator);

      int middle = start + span ~/ 2;
      _left = BVHNode(objects, start, middle);
      _right = BVHNode(objects, middle, end);
    }

    _boundingBox = AABB.fromBoxes(_left.boundingBox, _right.boundingBox);
  }

  factory BVHNode.fromList(Scene list) {
    return BVHNode(list.objects, 0, list.objects.length);
  }

  @override
  AABB get boundingBox => _boundingBox;

  @override
  (bool, HitRecord?) hit(Ray ray, Interval rayT, HitRecord? hitRecord) {
    if (!_boundingBox.hit(ray, rayT)) {
      return (false, null);
    }

    var (
      bool didHitLeft,
      HitRecord? leftHitRecord,
    ) = _left.hit(ray, rayT, hitRecord);
    hitRecord = leftHitRecord ?? hitRecord;

    var (
      bool didHitRight,
      HitRecord? rightHitRecord,
    ) = _right.hit(
      ray,
      Interval(
        rayT.min,
        didHitLeft ? leftHitRecord!.t : rayT.max,
      ),
      hitRecord,
    );
    hitRecord = rightHitRecord ?? hitRecord;

    return (didHitLeft || didHitRight, hitRecord);
  }

  int _compareBox(Hittable a, Hittable b, int axisIndex) {
    return a.boundingBox[axisIndex].min < b.boundingBox[axisIndex].min ? -1 : 1;
  }

  int _compareBoxX(Hittable a, Hittable b) {
    return _compareBox(a, b, 0);
  }

  int _compareBoxY(Hittable a, Hittable b) {
    return _compareBox(a, b, 1);
  }

  int _compareBoxZ(Hittable a, Hittable b) {
    return _compareBox(a, b, 2);
  }
}
