import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/shapes/sphere.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/materials/lambertial.dart';
import 'package:ray_tracing/materials/metal.dart';
import 'package:ray_tracing/utility/camera.dart';
import 'package:ray_tracing/utility/hittable_list.dart';

void main(List<String> args) async {
  HittableList world = HittableList();

  // world.add(
  //   Sphere(
  //     center: Point3(0, -100.5, -1),
  //     radius: 100,
  //     material: Lambertian(
  //       albedo: Color.fromHex(0xff386641),
  //     ),
  //   ),
  // );

  // world.add(
  //   Sphere(
  //     center: Point3(0, 0, -1),
  //     radius: 0.5,
  //     material: Lambertian(
  //       albedo: Color.fromHex(0xffc1121f),
  //     ),
  //   ),
  // );

  // ground
  world.add(
    Sphere(
      center: Point3(0, -100.5, -1),
      radius: 100,
      material: Lambertian(
        albedo: Color.fromHex(0xff6a994e),
      ),
    ),
  );

  // center sphere
  world.add(
    Sphere(
      center: Point3(0, 0, -1),
      radius: 0.5,
      material: Lambertian(
        albedo: Color.fromHex(0xffc1121f),
      ),
    ),
  );

  // left sphere
  world.add(
    Sphere(
      center: Point3(-1, 0, -1),
      radius: 0.5,
      material: Metal(
        albedo: Color.fromHex(0xffc1121f),
      ),
    ),
  );

  // right sphere
  world.add(
    Sphere(
      center: Point3(1, 0, -1),
      radius: 0.5,
      material: Metal(
        albedo: Color.fromHex(0xffc1121f),
      ),
    ),
  );

  // creates the camera and renders the scene.
  Camera camera = Camera(
    imageWidth: 1920,
    samplesPerPixel: 100,
    maxDepth: 50,
  );
  camera.render(world);
}
