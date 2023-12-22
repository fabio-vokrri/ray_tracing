/// Interval type: represents an interval of numbers
/// ranging from a minimum value to a maximum one.
class Interval {
  final double min, max;

  /// Creates an interval ranging from the given `minimum` to the `maximum` value.
  const Interval([this.min = 0, this.max = 0]);

  /// Creates an empty interval.
  const Interval.empty()
      : min = double.infinity,
        max = double.negativeInfinity;

  /// Creates an infinite interval.
  const Interval.universe()
      : min = double.negativeInfinity,
        max = double.infinity;

  /// Returns true if `x` is contained in this interval.
  bool contains(double x) {
    return x >= min && x <= max;
  }

  /// Returns true if `x` is strictly contained in this interval.
  bool surrounds(double x) {
    return x > min && x < max;
  }
}
