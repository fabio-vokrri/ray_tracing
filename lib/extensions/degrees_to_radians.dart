import 'dart:math';

extension ToRadians on double {
  double get toRadians {
    return this * pi / 180.0;
  }
}
