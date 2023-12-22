import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/utility/hit_record.dart';
import 'package:ray_tracing/utility/hittable.dart';
import 'package:ray_tracing/utility/interval.dart';

/// HittableList type: represents a list of hittable objects.
///
/// It contains all the object te scene is composed of.
class HittableList extends Hittable {
  final List<Hittable> _objects = [];

  HittableList([Hittable? object]) {
    if (object != null) {
      _objects.add(object);
    }
  }

  /// clears the list of objects.
  void clear() => _objects.clear();

  /// adds `object` to the list of objects.
  void add(Hittable object) {
    _objects.add(object);
  }

  @override
  (bool, HitRecord?) hit(
    Ray ray,
    Interval rayT,
    HitRecord? hitRecord,
  ) {
    HitRecord? temporaryRecord;
    bool anythingWasHit = false;
    double closest = rayT.max;

    // checks if the ray intersects any of the objects in the list
    for (Hittable object in _objects) {
      var (
        bool didHit,
        HitRecord? thisRecord,
      ) = object.hit(ray, Interval(rayT.min, closest), temporaryRecord);
      //                                               ^ warning!

      if (didHit) {
        anythingWasHit = true;
        temporaryRecord = thisRecord;

        // we check if the object was hit, so thisRecord is not null.
        closest = thisRecord!.t;
      }
    }

    return (anythingWasHit, temporaryRecord);
  }
}
