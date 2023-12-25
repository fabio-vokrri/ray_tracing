import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/materials/material.dart';
import 'package:ray_tracing/utility/hit_record.dart';

class Lambertian extends Material {
  final Color _albedo;
  Lambertian({required Color albedo}) : _albedo = albedo;

  @override
  (bool, Color, Ray) scatter(Ray ray, HitRecord record) {
    Vector3 scatterDirection = record.normal + Vector3.random().normalized;
    if (scatterDirection.isNearZero) {
      scatterDirection = record.normal;
    }

    Ray scatteredRay = Ray(
      origin: record.point,
      direction: scatterDirection,
      time: ray.time,
    );

    return (true, _albedo, scatteredRay);
  }
}
