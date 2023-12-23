import 'dart:math';

extension ToRadians on double {
  /// Returns the radians value of this degree.
  double get toRadians {
    return this * pi / 180.0;
  }
}
