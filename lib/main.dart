import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/shapes/sphere.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/materials/lambertial.dart';
import 'package:ray_tracing/materials/metal.dart';
import 'package:ray_tracing/utility/camera.dart';
import 'package:ray_tracing/utility/scene.dart';

void main(List<String> args) async {
  Scene scene = Scene();

  // scene.add(
  //   Sphere(
  //     center: Point3(0, -100.5, -1),
  //     radius: 100,
  //     material: Lambertian(
  //       albedo: Color.fromHex(0xff386641),
  //     ),
  //   ),
  // );

  // scene.add(
  //   Sphere(
  //     center: Point3(0, 0, -1),
  //     radius: 0.5,
  //     material: Lambertian(
  //       albedo: Color.fromHex(0xffc1121f),
  //     ),
  //   ),
  // );

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
      material: Metal(albedo: Color.black(), fuzz: 0.5),
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

  // double R = cos(pi / 4);

  // scene.add(
  //   Sphere(
  //     center: Point3(-R, 0, -1),
  //     radius: R,
  //     material: Lambertian(albedo: Color.fromDecimal(0, 0, 1)),
  //   ),
  // );
  // scene.add(
  //   Sphere(
  //     center: Point3(R, 0, -1),
  //     radius: R,
  //     material: Lambertian(albedo: Color.fromDecimal(1, 0, 0)),
  //   ),
  // );

  // creates the camera and renders the scene.
  Camera camera = Camera(
    imageWidth: 450,
    samplesPerPixel: 100,
    maxDepth: 50,
    verticalFOV: 20,
    lookFrom: Point3(-2, 2, 2),
  );
  camera.render(scene);
}
