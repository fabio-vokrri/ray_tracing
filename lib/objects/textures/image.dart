import 'package:image/image.dart' as image_lib;
import 'package:ray_tracing/geometry/color.dart';
import 'package:ray_tracing/geometry/vector.dart';
import 'package:ray_tracing/objects/textures/texture.dart';
import 'package:ray_tracing/utility/image_loader.dart';
import 'package:ray_tracing/utility/interval.dart';

class Image extends Texture {
  final image_lib.Image _image;

  Image(String imagePath)
      : _image = image_lib.decodeImage(
          loadImage(imagePath).readAsBytesSync(),
        )!;

  @override
  Color value(double u, double v, Point3 point) {
    if (_image.height <= 0) return Color.fromRGB(0, 255, 255);

    u = Interval(0, 1).clamp(u).toDouble();
    v = 1 - Interval(0, 1).clamp(v).toDouble();

    int i = (u * _image.width).toInt();
    int j = (v * _image.height).toInt();

    image_lib.Pixel pixel = _image.getPixel(i, j);

    double colorScale = 1 / 255;
    return Color.fromDecimal(
      pixel.r * colorScale,
      pixel.g * colorScale,
      pixel.b * colorScale,
    );
  }
}
