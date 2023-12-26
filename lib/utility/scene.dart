import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/utility/aabb.dart';
import 'package:ray_tracing/utility/hit_record.dart';
import 'package:ray_tracing/utility/hittable.dart';
import 'package:ray_tracing/utility/interval.dart';

/// HittableList type: represents a list of hittable objects.
///
/// It contains all the object te scene is composed of.
class Scene extends Hittable {
  List<Hittable> objects = [];
  AABB _boundingBox = AABB();

  /// Creates a new Scene with the given `object`.
  Scene([Hittable? object]);

  /// clears the list of objects.
  void clear() => objects.clear();

  /// adds `object` to the list of objects.
  void add(Hittable object) {
    objects.add(object);
    _boundingBox = AABB.fromBoxes(_boundingBox, object.boundingBox);
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
    for (Hittable object in objects) {
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

  @override
  AABB get boundingBox => _boundingBox;
}
