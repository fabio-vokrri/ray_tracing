import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/utility/hit_record.dart';

abstract class Material {
  (bool didScatter, Color attenuation, Ray scatteredRay) scatter(
    Ray ray,
    HitRecord record,
  );
}
