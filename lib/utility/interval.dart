import 'dart:math' as math;

/// Interval type: represents an interval of numbers
/// ranging from a minimum value to a maximum one.
class Interval {
  final double min, max;

  /// Creates a new interval ranging from the given `minimum` to the `maximum` value.
  const Interval([this.min = 0, this.max = 0]);

  /// Creates a new empty interval.
  const Interval.empty()
      : min = double.infinity,
        max = double.negativeInfinity;

  /// Creates a new infinite interval.
  const Interval.universe()
      : min = double.negativeInfinity,
        max = double.infinity;

  /// Creates a new interval from the given ones.
  Interval.fromIntervals(Interval a, Interval b)
      : min = math.min(a.min, b.min),
        max = math.max(a.max, b.max);

  /// Expands this interval by `delta`.
  Interval expand(double delta) {
    double padding = delta / 2;
    return Interval(min - padding, max + padding);
  }

  /// Returns a new copy of this interval with the given `max` and `min` values.
  Interval copyWith({double? min, double? max}) {
    return Interval(min ?? this.min, max ?? this.max);
  }

  /// Returns true if `x` is contained in this interval.
  bool contains(double x) {
    return x >= min && x <= max;
  }

  /// Returns true if `x` is strictly contained in this interval.
  bool surrounds(double x) {
    return x > min && x < max;
  }

  /// Clamps the value of `x` between the max and the min value of this interval.
  double clamp(double x) {
    if (x < min) return min;
    if (x > max) return max;

    return x;
  }

  /// Returns the size of this interval.
  double get size {
    return max - min;
  }

  /// Adds the given `displacement` to the minimum and maximum of this interval.
  Interval operator +(num displacement) {
    return Interval(min + displacement, max + displacement);
  }
}
