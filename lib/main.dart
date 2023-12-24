import 'dart:math';

import 'package:ray_tracing/extensions/random_double.dart';
import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/shapes/sphere.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/materials/dielectric.dart';
import 'package:ray_tracing/materials/lambertial.dart';
import 'package:ray_tracing/materials/material.dart';
import 'package:ray_tracing/materials/metal.dart';
import 'package:ray_tracing/utility/camera.dart';
import 'package:ray_tracing/utility/scene.dart';

void main(List<String> args) async {
  // creates the camera and renders the scene.
  Camera camera = Camera(
    imageWidth: 100,
    samplesPerPixel: 100,
    maxDepth: 50,
    verticalFOV: 20,
    lookFrom: Point3(13, 2, 3),
    defocusAngle: 0.6,
    focusDistance: 10,
  );

  camera.render(scene4);
}

Scene get scene1 {
  Scene scene = Scene();

  scene.add(
    Sphere(
      center: Point3(0, -100.5, -1),
      radius: 100,
      material: Lambertian(
        albedo: Color.fromHex(0xff386641),
      ),
    ),
  );

  scene.add(
    Sphere(
      center: Point3(0, 0, -1),
      radius: 0.5,
      material: Lambertian(
        albedo: Color.fromHex(0xffc1121f),
      ),
    ),
  );

  return scene;
}

Scene get scene2 {
  Scene scene = Scene();
  // ground
  scene.add(
    Sphere(
      center: Point3(0, -100.5, -1),
      radius: 100,
      material: Lambertian(
        albedo: Color.fromDecimal(0.8, 0.8, 0),
      ),
    ),
  );

  // center sphere
  scene.add(
    Sphere(
      center: Point3(0, 0, 0),
      radius: 0.5,
      material: Lambertian(
        albedo: Color.fromDecimal(0.7, 0.3, 0.3),
      ),
    ),
  );

  // left sphere
  scene.add(
    Sphere(
      center: Point3(-1, 0, 0),
      radius: 0.5,
      material: Metal(albedo: Color.fromHex(0xff023047)),
    ),
  );

  // right sphere
  scene.add(
    Sphere(
      center: Point3(1, 0, 0),
      radius: 0.5,
      material: Metal(albedo: Color.fromDecimal(0.8, 0.6, 0.2)),
    ),
  );

  return scene;
}

Scene get scene3 {
  Scene scene = Scene();
  double R = cos(pi / 4);

  scene.add(
    Sphere(
      center: Point3(-R, 0, -1),
      radius: R,
      material: Lambertian(albedo: Color.fromDecimal(0, 0, 1)),
    ),
  );
  scene.add(
    Sphere(
      center: Point3(R, 0, -1),
      radius: R,
      material: Lambertian(albedo: Color.fromDecimal(1, 0, 0)),
    ),
  );

  return scene;
}

Scene get scene4 {
  Random random = Random();
  Scene scene = Scene();

  Material groundMaterial = Lambertian(albedo: Color.fromHex(0xffa7c957));
  scene.add(
    Sphere(center: Point3(0, -1000, 0), radius: 1000, material: groundMaterial),
  );

  for (var i = -11; i < 11; i++) {
    for (var j = -11; j < 11; j++) {
      double chooseMaterial = random.nextDouble();
      Point3 center = Point3(
        i + 0.9 * random.nextDouble(),
        0.2,
        j * 0.9 * random.nextDouble(),
      );

      if ((center - Point3(4, 0.2, 0)).length > 0.9) {
        Material material;

        if (chooseMaterial < 0.8) {
          Color color = Color.random();
          material = Lambertian(albedo: color);
        } else if (chooseMaterial < 0.95) {
          Color color = Color.randomBetween(0.5, 1);
          double fuzz = random.nextDoubleBetween(0, 0.5);
          material = Metal(albedo: color, fuzz: fuzz);
        } else {
          material = Dielectric(refractionIndex: 1.5);
        }

        scene.add(
          Sphere(center: center, radius: 0.2, material: material),
        );
      }
    }
  }

  scene.add(
    Sphere(
      center: Point3(0, 1, 0),
      radius: 1,
      material: Dielectric(refractionIndex: 1.5),
    ),
  );

  scene.add(
    Sphere(
      center: Point3(-4, 1, 0),
      radius: 1.0,
      material: Lambertian(
        albedo: Color.fromDecimal(0.4, 0.2, 0.1),
      ),
    ),
  );

  scene.add(
    Sphere(
      center: Point3(4, 1, 0),
      radius: 1,
      material: Metal(
        albedo: Color.fromDecimal(0.7, 0.6, 0.5),
      ),
    ),
  );

  return scene;
}
