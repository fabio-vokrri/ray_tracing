import 'dart:math';

extension RandomDouble on Random {
  /// Returns a random double between `min` (inclusive) and `max` (exclusive)
  double nextDoubleBetween(double min, double max) {
    return min + (max - min) * nextDouble();
  }
}
