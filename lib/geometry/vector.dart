import 'dart:math';

import 'package:ray_tracing/const.dart';
import 'package:ray_tracing/extensions/random_double.dart';

/// Vector3 type: represents a three-dimensional vector.
class Vector3 {
  final double _x;
  final double _y;
  final double _z;

  /// Creates a new vector with the given `x`, `y` and `z` components.
  const Vector3(double x, double y, double z)
      : _x = x,
        _y = y,
        _z = z;

  /// Creas a vector in the origin with length 0.
  const Vector3.origin()
      : _x = 0,
        _y = 0,
        _z = 0;

  /// Creates a vector with random components
  /// ranging from 0 (inclusive) to 1 (exclusive).
  factory Vector3.random() {
    Random random = Random();

    return Vector3(
      random.nextDouble(),
      random.nextDouble(),
      random.nextDouble(),
    );
  }

  /// Creates a vector with random components
  /// ranging from `min` (inclusive) to `max` (exclusive).
  factory Vector3.randomBetween(double min, double max) {
    Random random = Random();

    return Vector3(
      random.nextDoubleBetween(min, max),
      random.nextDoubleBetween(min, max),
      random.nextDoubleBetween(min, max),
    );
  }

  /// Creates a vector with random components
  /// ranging from -1 (inclusive) and 1 (exclusive)
  /// having squared length smaller than 1.
  factory Vector3.randomInUnitSphere() {
    Random random = Random();

    Vector3 p;
    while (true) {
      p = Vector3(
        random.nextDoubleBetween(-1, 1),
        random.nextDoubleBetween(-1, 1),
        random.nextDoubleBetween(-1, 1),
      );

      if (p.squaredLength < 1) {
        return p;
      }
    }
  }

  /// Creates a random unit vector on the correct hemisphere
  /// indicated by the given `normal` vector.
  factory Vector3.randomOnHemisphere(Vector3 normal) {
    Vector3 onUnitSphere = Vector3.random().normalized;
    if (onUnitSphere.dot(normal) > 0) {
      return onUnitSphere;
    } else {
      return -onUnitSphere;
    }
  }

  // Creates a vector with random x, y components
  /// ranging from -1 (inclusive) and 1 (exclusive)
  /// having squared length smaller than 1.
  factory Vector3.randomInUnitDisk() {
    Random random = Random();

    Vector3 p;
    while (true) {
      p = Vector3(
        random.nextDoubleBetween(-1, 1),
        random.nextDoubleBetween(-1, 1),
        0,
      );

      if (p.squaredLength < 1) {
        return p;
      }
    }
  }

  double get x => _x;
  double get y => _y;
  double get z => _z;

  /// Returns the vector length, defined as the vector modulus.
  double get length => sqrt(squaredLength);

  /// Returns the vector length squared.
  double get squaredLength => _x * _x + _y * _y + _z * _z;

  /// Returns a new vector with unit modulus (whose length is 1) from this vector.
  ///
  /// Returns this vector if its length is zero or one.
  Vector3 get normalized {
    if (length == 0 || length == 1) return this;
    return this / length;
  }

  /// Returns true if the absolute value of every component
  /// of this vector is smaller than 1e-8.
  bool get isNearZero {
    return _x.abs() < precision && _y.abs() < precision && _z.abs() < precision;
  }

  /// Returns a new vector whose components are the sum between
  /// the components of this vector and the ones of `other`.
  Vector3 operator +(Vector3 other) {
    return Vector3(_x + other.x, _y + other.y, _z + other.z);
  }

  /// Returns a new vector whose components are the difference between
  /// the components of this vector and the ones of `other`.
  Vector3 operator -(Vector3 other) {
    return Vector3(_x - other.x, _y - other.y, _z - other.z);
  }

  /// Returns a new vector whose components are the negated version
  /// of the components of this vector.
  Vector3 operator -() {
    return Vector3(-_x, -_y, -_z);
  }

  /// Returns a new vector whose components are generated from the product
  /// of every component of this vector by `t`.
  Vector3 operator *(num t) {
    return Vector3(_x * t, _y * t, _z * t);
  }

  /// Returns a new vector whose components are generated from the division
  /// of every component of this vector by `t`.
  ///
  /// Throws `ArgumentException` if the given number is 0.
  Vector3 operator /(num t) {
    if (t == 0) {
      throw ArgumentError("Division by zero not supported");
    }
    return this * (1 / t);
  }

  /// Returns the `i`-th axis of this vector.
  ///
  /// Throws Argument error if `i` is out of range.
  double operator [](int i) {
    if (i < 0 || i > 3) {
      throw ArgumentError.value(i, null, "Index out of bounds");
    }

    if (i == 0) return _x;
    if (i == 1) return _y;
    return _z;
  }

  /// Returns a new vector generated from the product of every component
  /// of this vector with the corresponding component of `other`.
  Vector3 multiplyBy(Vector3 other) {
    return Vector3(_x * other.x, _y * other.y, _z * other.z);
  }

  /// Returns a new vector whose components are generated from the cross product
  /// between this vector and `other`.
  Vector3 cross(Vector3 other) {
    return Vector3(
      _y * other.z - _z * other.y,
      _z * other.x - _x * other.z,
      _x * other.y - _y * other.x,
    );
  }

  /// Returns the dot product between this vector and `other`.
  double dot(Vector3 other) {
    return _x * other.x + _y * other.y + _z * other.z;
  }

  /// Returns the direction a reflected ray on a surface.
  Vector3 reflect(Vector3 normal) {
    return this - normal * (2 * dot(normal));
  }

  /// Returns the direction a refracted ray on a surface.
  Vector3 refract(Vector3 normal, double refractionIndex) {
    double cosTheta = min((-this).dot(normal), 1);
    Vector3 rOutPerpendicular = (this + normal * cosTheta) * refractionIndex;
    Vector3 rOutParallel =
        normal * -sqrt((1 - rOutPerpendicular.squaredLength).abs());

    return rOutPerpendicular + rOutParallel;
  }
}

/// Point3 type: represents a point a three-dimensional space.
///
/// A point in space can be represented as a vector having its
/// tail at (0, 0, 0) and its tip at the corresponding coordinates.
typedef Point3 = Vector3;