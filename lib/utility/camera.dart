import 'dart:io';
import 'dart:math';

import 'package:ray_tracing/extensions/to_radians.dart';
import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/ray.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/utility/hit_record.dart';
import 'package:ray_tracing/utility/hittable.dart';
import 'package:ray_tracing/utility/interval.dart';
import 'package:ray_tracing/utility/scene.dart';

/// Camera type: represents the settings of a camera.
class Camera {
  final Random _random = Random();

  final double aspectRatio;
  final int imageWidth;
  final Color backgroundColor;
  final int samplesPerPixel;
  final int maxDepth;

  final double verticalFOV;
  final Point3 lookFrom;
  final Point3 lookAt;
  final Vector3 cameraUpDirection;

  late int _imageHeight;
  late Point3 _cameraCenter;
  late Point3 _firstPixelLocation;
  late Vector3 _pixelDeltaU, _pixelDeltaV;
  late Vector3 _u, _v, _w;

  /// Creates a new camera.
  Camera({
    this.aspectRatio = 16 / 9,
    this.imageWidth = 100,
    this.backgroundColor = const Color.black(),
    this.samplesPerPixel = 10,
    this.maxDepth = 10,
    //
    this.verticalFOV = 90,
    this.lookFrom = const Point3(0, 0, -1),
    this.lookAt = const Point3.origin(),
    this.cameraUpDirection = const Vector3(0, 1, 0),
  }) {
    // calculates the image height base on the given aspect ratio and width
    _imageHeight = imageWidth ~/ aspectRatio;
    _imageHeight = _imageHeight < 1 ? 1 : _imageHeight;

    _cameraCenter = lookFrom;

    // camera settings
    double focalLength = (lookFrom - lookAt).length;
    double theta = verticalFOV.toRadians;
    double viewportHeight = 2 * tan(theta / 2) * focalLength;
    double viewportWidth = viewportHeight * imageWidth / _imageHeight;

    // calculates the u, v, w unit basis vectors for the camera coordinate frame.
    _w = (lookFrom - lookAt).normalized;
    _u = cameraUpDirection.cross(_w).normalized;
    _v = _w.cross(_u);

    // calculates the vectors across the horizontal and down vertical viewport edges
    Vector3 viewportU = _u * viewportWidth;
    Vector3 viewportV = (-_v) * viewportHeight;

    // calculates the horizontal and vertical delta vectors from pixel to pixel
    _pixelDeltaU = viewportU / imageWidth;
    _pixelDeltaV = viewportV / _imageHeight;

    // calculates the location of the upper left pixel
    Point3 viewportUpperLeftLocation =
        _cameraCenter - (_w * focalLength) - viewportU / 2 - viewportV / 2;
    _firstPixelLocation =
        viewportUpperLeftLocation + (_pixelDeltaU + _pixelDeltaV) * 0.5;
  }

  /// Renders the given scene.
  void render(Scene world) async {
    // creates a buffer that will be written in the output image file (PPM format)
    StringBuffer content = StringBuffer("P3\n$imageWidth $_imageHeight\n255\n");

    // color scaler, used for antu aliasing
    double scale = 1 / samplesPerPixel;
    for (int i = 0; i < _imageHeight; i++) {
      stdout.write("\rLines remaining: ${_imageHeight - i}\n");
      for (int j = 0; j < imageWidth; j++) {
        Color pixelColor = Color.black();
        for (int k = 0; k < samplesPerPixel; k++) {
          Ray ray = _getRay(i, j);
          pixelColor += _getRayColor(ray, maxDepth, world);
        }
        pixelColor *= scale;
        content.write(pixelColor);
      }
    }
    stdout.write("\n\rDONE!\n");

    // creates the image output file
    File image = File("outputs/out.ppm");
    // and writes the content buffer in it
    await image.writeAsString(content.toString());
  }

  /// Returns the color of the given `ray` that hits the objects in the given `scene`
  /// for a maximum of `depth` times.
  Color _getRayColor(Ray ray, int depth, Hittable scene) {
    if (depth <= 0) {
      return Color.black();
    }

    var (
      bool didHit,
      HitRecord? hitRecord,
    ) = scene.hit(ray, Interval(0.001, double.infinity), null);

    if (didHit) {
      var (
        bool didScatter,
        Color attenuation,
        Ray scatteredRay,
      ) = hitRecord!.material.scatter(ray, hitRecord);

      if (didScatter) {
        return _getRayColor(
          scatteredRay,
          depth - 1,
          scene,
        ).multiplyBy(attenuation);
      }

      return Color.black();
    }

    // calculates color gradient of the sky
    Vector3 unitDirection = ray.direction.normalized;
    double a = 0.5 * (unitDirection.y + 1);
    return Color.white() * (1 - a) + Color.fromHex(0xff8ecae6) * a;
  }

  /// Returns the ray at the given pixel location, with a small random offset,
  /// in order to get multiple samples of color for the same pixel.
  ///
  /// Used for antialiasing.
  Ray _getRay(int i, int j) {
    Point3 pixelCenter =
        _firstPixelLocation + (_pixelDeltaU * j) + (_pixelDeltaV * i);
    Vector3 pixelSample = pixelCenter + _pixelCenterSquare();

    Point3 rayOrigin = _cameraCenter;
    Vector3 rayDirection = pixelSample - rayOrigin;

    return Ray(origin: rayOrigin, direction: rayDirection);
  }

  /// Returns the offset used in the calculation of the color of a single pixel.
  ///
  /// Used for antialiasing.
  Vector3 _pixelCenterSquare() {
    var px = -0.5 + _random.nextDouble();
    var py = -0.5 + _random.nextDouble();

    return (_pixelDeltaU * px) + (_pixelDeltaV * py);
  }
}
