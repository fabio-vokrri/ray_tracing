import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/utility/hit_record.dart';

/// Material Type: represents the material of an object.
abstract class Material {
  /// Scatters the given ray.
  (bool didScatter, Color attenuation, Ray scatteredRay) scatter(
    Ray ray,
    HitRecord record,
  );

  Color emit(double u, double v, Point3 point) {
    return Color.black();
  }
}
