import 'dart:io';

import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/geometry/vector.dart';

void main(List<String> args) async {
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
      content.write(ray.color); // toString method automatically invoked
    }
  }

  stdout.write("\n\rDONE!\n");

  // creates the image output file
  File image = File("outputs/output_image.ppm");
  // and writes the content buffer in it
  await image.writeAsString(content.toString());
}
