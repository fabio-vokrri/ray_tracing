import 'package:ray_tracing/extensions/to_gamma.dart';
import 'package:ray_tracing/utility/interval.dart';

/// Color type: represents a color
class Color {
  final double _r;
  final double _g;
  final double _b;

  // private constructor
  const Color._(double r, double g, double b)
      : _r = r,
        _g = g,
        _b = b;

  /// Returns a new color from its hexadecimal representation
  factory Color.fromHex(int hex) {
    double r = ((hex >> 16) & 0xFF) / 255; // gets r channel
    double g = ((hex >> 8) & 0xFF) / 255; // gets g channel
    double b = (hex & 0xFF) / 255; // gets b channel

    return Color._(r, g, b);
  }

  /// Creates a new color from the given `r`, `g`, `b` channels, ranging from 0 to 255, inclusive.
  factory Color.fromRGB(int r, int g, int b) {
    return Color._(r / 255, g / 255, b / 255);
  }

  /// Creates a new color from the given `r`, `g`, `b` channels, ranging from 0 to 1, inclusive.
  factory Color.fromDecimal(double r, double g, double b) {
    return Color._(r, g, b);
  }

  /// Creates a new white color.
  const Color.white()
      : _r = 1,
        _g = 1,
        _b = 1;

  /// Creates a black color.
  const Color.black()
      : _r = 0,
        _g = 0,
        _b = 0;

  double get r => _r;
  double get g => _g;
  double get b => _b;

  /// Returns a new color whose channels are the sum between
  /// the channels of this color and the ones of `other`.
  Color operator +(Color other) {
    return Color._(_r + other.r, _g + other.g, _b + other.b);
  }

  /// Returns a new color whose channels are the difference between
  /// the channels of this color and the ones of `other`.
  Color operator -(Color other) {
    return Color._(r - other.r, g - other.g, b - other.b);
  }

  /// Returns a new color whose channels are generated from
  /// the product of every channel of this color by `t`.
  Color operator *(num t) {
    if (t < 0) {
      throw ArgumentError.value(t, null, "Cannot have negative r g b values");
    }

    return Color._(_r * t, _g * t, _b * t);
  }

  /// Returns a new color whose channels are generated from
  /// the division of every channel of this color by `t`.
  Color operator /(int t) {
    if (t < 0) {
      throw ArgumentError.value(t, null, "Cannot have negative r g b values");
    }

    if (t == 0) {
      throw ArgumentError("Division by zero not supported");
    }

    return Color._(r / t, g / t, b / t);
  }

  /// Returns a new color whose channels are generated from
  /// the product of every channel of this color with the ones of `other`.
  Color multiplyBy(Color other) {
    return Color._(_r * other.r, _g * other.g, _b * other.b);
  }

  /// Returns a string representation of this color.
  @override
  String toString() {
    Interval intensity = Interval(0, 0.999);

    // removed gamma correction
    int r = (intensity.clamp(this.r.toGamma) * 256).toInt();
    int g = (intensity.clamp(this.g.toGamma) * 256).toInt();
    int b = (intensity.clamp(this.b.toGamma) * 256).toInt();

    return "$r $g $b\n";
  }
}
