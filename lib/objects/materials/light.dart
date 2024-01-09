import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/objects/materials/material.dart';
import 'package:ray_tracing/objects/textures/solid_color.dart';
import 'package:ray_tracing/objects/textures/texture.dart';
import 'package:ray_tracing/utility/hit_record.dart';

class Light extends Material {
  final Texture _emit;

  Light(Texture texture) : _emit = texture;
  Light.fromColor(Color color) : _emit = SolidColor(color);

  @override
  (bool, Color, Ray) scatter(Ray ray, HitRecord record) {
    return (false, Color.white(), ray);
  }

  @override
  Color emit(double u, double v, Point3 point) {
    return _emit.value(u, v, point);
  }
}
