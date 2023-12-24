import 'dart:math';

import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/materials/material.dart';
import 'package:ray_tracing/utility/hit_record.dart';

class Dielectric extends Material {
  final Random _random = Random();

  final double _refractionIndex;
  Dielectric({required double refractionIndex})
      : _refractionIndex = refractionIndex;

  @override
  (bool, Color, Ray) scatter(Ray ray, HitRecord record) {
    Color attenuation = Color.white();

    double refractionRatio =
        record.isFrontFace ? (1 / _refractionIndex) : _refractionIndex;

    Vector3 unitDirection = ray.direction.normalized;
    double cosTheta = min((-unitDirection).dot(record.normal), 1);
    double sinTheta = sqrt(1 - cosTheta * cosTheta);

    bool cannotRefract = refractionRatio * sinTheta > 1;

    Vector3 direction;
    if (cannotRefract ||
        _reflectance(cosTheta, refractionRatio) > _random.nextDouble()) {
      direction = unitDirection.reflect(record.normal);
    } else {
      direction = unitDirection.refract(record.normal, refractionRatio);
    }

    Ray scattered = Ray(
      origin: record.point,
      direction: direction,
    );

    return (true, attenuation, scattered);
  }

  double _reflectance(double cosine, double refractionIndex) {
    double r0 = (1 - refractionIndex) / (1 + refractionIndex);
    r0 *= r0;
    return r0 + (1 - r0) * pow(1 - cosine, 5);
  }
}
