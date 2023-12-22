import 'dart:io';

import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/geometry/shapes/sphere.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/utility/hit_record.dart';
import 'package:ray_tracing/utility/hittable.dart';
import 'package:ray_tracing/utility/hittable_list.dart';
import 'package:ray_tracing/utility/interval.dart';

void main(List<String> args) async {
  // creates a new scene composed of two spheres, one on top of another.
  HittableList world = HittableList();
  world.add(Sphere(center: Point3(0, 0, -1), radius: 0.5));
  world.add(Sphere(center: Point3(0, -100.5, -1), radius: 100));

  double aspectRatio = 16 / 9;
  int width = 1920;
  // calculates the image height base on the given aspect ratio and width
  int heigth = width ~/ aspectRatio;
  heigth = heigth < 1 ? 1 : heigth;

  // camera settings
  double focalLength = 1;
  double viewportHeight = 2;
  double viewportWidth = viewportHeight * width / heigth;
  Point3 cameraCenter = Point3(0, 0, 0);

  // calculates the vectors across the horizontal and down vertical viewport edges
  Vector3 viewportU = Vector3(viewportWidth, 0, 0);
  Vector3 viewportV = Vector3(0, -viewportHeight, 0);

  // calculates the horizontal and vertical delta vectors from pixel to pixel
  Vector3 pixelDeltaU = viewportU / width;
  Vector3 pixelDeltaV = viewportV / heigth;

  // calculates the location of the upper left pixel
  Point3 viewportUpperLeftLocation =
      cameraCenter - Vector3(0, 0, focalLength) - viewportU / 2 - viewportV / 2;
  Point3 firstPixelLocation =
      viewportUpperLeftLocation + (pixelDeltaU + pixelDeltaV) / 2;

  // creates a buffer that will be written in the output image file (PPM format)
  StringBuffer content = StringBuffer("P3\n$width $heigth\n255\n");

  for (int i = 0; i < heigth; i++) {
    stdout.write("\rLines remaining: ${heigth - i}\n");
    for (int j = 0; j < width; j++) {
      Point3 pixelCenter =
          firstPixelLocation + (pixelDeltaU * j) + (pixelDeltaV * i);
      Vector3 rayDirection = pixelCenter - cameraCenter;

      Ray ray = Ray(origin: cameraCenter, direction: rayDirection);
      content.write(
          getRayColor(ray, world)); // toString method automatically invoked
    }
  }
  stdout.write("\n\rDONE!\n");

  // creates the image output file
  File image = File("outputs/output_image.ppm");
  // and writes the content buffer in it
  await image.writeAsString(content.toString());
}

/// Returns the color of `ray` after hitting an object of `world`.
Color getRayColor(Ray ray, Hittable world) {
  var (
    bool didHit,
    HitRecord? hitRecord,
  ) = world.hit(ray, Interval(0, double.infinity), null);

  if (didHit) {
    Vector3 normal = hitRecord!.normal;
    return (Color.white() + Color.fromDecimal(normal.x, normal.y, normal.z)) *
        0.5;
  }

  // calculates color gradient of the sky
  Vector3 unitDirection = ray.direction.normalized;
  double a = 0.5 * (unitDirection.y + 1);

  return Color.white() * (1 - a) + Color.fromHex(0xFF8ECAE6) * a;
}
