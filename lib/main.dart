import 'package:ray_tracing/geometry/shapes/sphere.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/utility/camera.dart';
import 'package:ray_tracing/utility/hittable_list.dart';

void main(List<String> args) async {
  // creates a new scene composed of two spheres, one on top of another.
  HittableList world = HittableList();
  world.add(Sphere(center: Point3(0, 0, -1), radius: 0.5));
  world.add(Sphere(center: Point3(0, -100.5, -1), radius: 100));

  Camera camera = Camera(imageWidth: 1920);
  camera.render(world);
}
