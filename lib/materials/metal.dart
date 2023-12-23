import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/materials/material.dart';
import 'package:ray_tracing/utility/hit_record.dart';

class Metal extends Material {
  final Color _albedo;
  Metal({required Color albedo}) : _albedo = albedo;

  @override
  (bool, Color, Ray) scatter(Ray ray, HitRecord record) {
    Vector3 reflected = ray.direction.normalized.reflect(record.normal);
    Ray scatteredRay = Ray(
      origin: record.point,
      direction: reflected,
    );

    return (true, _albedo, scatteredRay);
  }
}
