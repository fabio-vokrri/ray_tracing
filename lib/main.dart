import 'dart:math';

import 'package:ray_tracing/extensions/random_double.dart';
import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/objects/materials/dielectric.dart';
import 'package:ray_tracing/objects/materials/lambertian.dart';
import 'package:ray_tracing/objects/materials/light.dart';
import 'package:ray_tracing/objects/materials/material.dart';
import 'package:ray_tracing/objects/materials/metal.dart';
import 'package:ray_tracing/objects/shapes/quadrilateral.dart';
import 'package:ray_tracing/objects/shapes/sphere.dart';
import 'package:ray_tracing/objects/textures/checker.dart';
import 'package:ray_tracing/objects/textures/image.dart';
import 'package:ray_tracing/objects/textures/noise.dart';
import 'package:ray_tracing/objects/textures/texture.dart';
import 'package:ray_tracing/utility/camera.dart';
import 'package:ray_tracing/utility/scene.dart';

void main(List<String> args) async {
  // creates the camera and renders the scene.
  Camera camera = Camera(
    aspectRatio: 1,
    imageWidth: 400,
    samplesPerPixel: 100,
    maxDepth: 50,
    verticalFOV: 40,
    lookFrom: Point3(278, 278, -800),
    lookAt: Point3(278, 278, 0),
  );

  camera.render(scene9);
}

Scene get scene1 {
  Scene scene = Scene();

  scene.add(
    Sphere(
      center: Point3(0, -100.5, 0),
      radius: 100,
      material: Lambertian(
        albedo: Color.fromHex(0xff386641),
      ),
    ),
  );

  scene.add(
    Sphere(
      center: Point3.origin(),
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

  Material groundMaterial = Lambertian.fromTexture(
    Checker.fromColors(
      0.32,
      Color.white(),
      Color.black(),
    ),
  );
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

Scene get scene5 {
  Scene scene = Scene();

  scene.add(
    Sphere(
      center: Vector3.origin(),
      radius: 2,
      material: Lambertian.fromTexture(
        Image(r"assets\earth_texture.jpg"),
      ),
    ),
  );
  return scene;
}

Scene get scene6 {
  Scene scene = Scene();
  scene.add(
    Sphere(
      center: Point3.origin(),
      radius: 0.5,
      material: Lambertian.fromTexture(Noise()),
    ),
  );

  scene.add(
    Sphere(
      center: Point3(0, -100.5, 0),
      radius: 100,
      material: Lambertian.fromTexture(Noise()),
    ),
  );

  return scene;
}

Scene get scene7 {
  Scene scene = Scene();

  Material left = Lambertian(albedo: Color.fromDecimal(1, 0.2, 0.2));
  Material right = Lambertian(albedo: Color.fromDecimal(0.2, 1, 0.2));
  Material top = Lambertian(albedo: Color.fromDecimal(0.2, 0.2, 1));
  Material bottom = Lambertian(albedo: Color.fromDecimal(1, 0.5, 0));
  Material back = Lambertian(albedo: Color.fromDecimal(1, 0, 0.5));

  scene.add(
    Quadrilateral(
      q: Point3(-3, -2, 5),
      u: Vector3(0, 0, -4),
      v: Vector3(0, 4, 0),
      material: left,
    ),
  );
  scene.add(
    Quadrilateral(
      q: Point3(-2, -2, 0),
      u: Vector3(4, 0, 0),
      v: Vector3(0, 4, 0),
      material: back,
    ),
  );
  scene.add(
    Quadrilateral(
      q: Point3(3, -2, 1),
      u: Vector3(0, 0, 4),
      v: Vector3(0, 4, 0),
      material: right,
    ),
  );
  scene.add(
    Quadrilateral(
      q: Point3(-2, 3, 1),
      u: Vector3(4, 0, 0),
      v: Vector3(0, 0, 4),
      material: top,
    ),
  );
  scene.add(
    Quadrilateral(
      q: Point3(-2, -3, 5),
      u: Vector3(4, 0, 0),
      v: Vector3(0, 0, -4),
      material: bottom,
    ),
  );

  return scene;
}

Scene get scene8 {
  Scene scene = Scene();

  Texture noise = Noise(scale: 4);
  scene.add(
    Sphere(
      center: Point3(0, -10000, 0),
      radius: 10000,
      material: Lambertian.fromTexture(noise),
    ),
  );

  scene.add(
    Sphere(
      center: Point3(0, 2, 0),
      radius: 2,
      material: Lambertian.fromTexture(noise),
    ),
  );

  Material light = Light.fromColor(Color.white());
  scene.add(
    Sphere(
      center: Point3(0, 200, 0),
      radius: 100,
      material: light,
    ),
  );

  return scene;
}

Scene get scene9 {
  Scene scene = Scene();
  var red = Lambertian(albedo: Color.fromDecimal(0.65, 0.5, 0.5));
  var white = Lambertian(albedo: Color.fromDecimal(0.73, 0.73, 0.73));
  var green = Lambertian(albedo: Color.fromDecimal(0.12, 0.45, 0.15));
  var light = Light.fromColor(Color.white());

  scene.add(
    Quadrilateral(
      q: Point3(555, 0, 0),
      u: Vector3(0, 555, 0),
      v: Vector3(0, 0, 555),
      material: green,
    ),
  );
  scene.add(
    Quadrilateral(
      q: Point3(0, 0, 0),
      u: Vector3(0, 555, 0),
      v: Vector3(0, 0, 555),
      material: red,
    ),
  );
  scene.add(
    Quadrilateral(
      q: Point3(343, 554, 332),
      u: Vector3(-130, 0, 0),
      v: Vector3(0, 0, -105),
      material: light,
    ),
  );
  scene.add(
    Quadrilateral(
      q: Point3(0, 0, 0),
      u: Vector3(555, 0, 0),
      v: Vector3(0, 0, 555),
      material: white,
    ),
  );
  scene.add(
    Quadrilateral(
      q: Point3(555, 555, 555),
      u: Vector3(-555, 0, 0),
      v: Vector3(0, 0, -555),
      material: white,
    ),
  );
  scene.add(
    Quadrilateral(
      q: Point3(0, 0, 555),
      u: Vector3(555, 0, 0),
      v: Vector3(0, 555, 0),
      material: white,
    ),
  );

  return scene;
}
