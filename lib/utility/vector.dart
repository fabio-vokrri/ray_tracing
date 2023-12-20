import 'dart:math';

/// Vector3 type: represents a three-dimensional vector.
class Vector3 {
  final double _x;
  final double _y;
  final double _z;

  const Vector3(double x, double y, double z)
      : _x = x,
        _y = y,
        _z = z;

  const Vector3.zero()
      : _x = 0,
        _y = 0,
        _z = 0;

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

  /// Returns a new vector whose components are the sum between 
  /// the components of this vectori and the ones of `other`.
  Vector3 operator +(Vector3 other) {
    return Vector3(
      _x + other.x,
      _y + other.y,
      _z + other.z,
    );
  }

  /// Returns a new vector whose components are the difference between
  /// the components of this vector and the ones of `other`.
  Vector3 operator -(Vector3 other) {
    return Vector3(
      _x - other.x,
      _y - other.y,
      _z - other.z,
    );
  }

  /// Returns a new vector whose components are the negated version
  /// of the components of this vector.
  Vector3 operator -() {
    return Vector3(
      -_x,
      -_y,
      -_z,
    );
  }

  /// Returns a new vector whose components are generated from the product
  /// of every component of this vector by `t`.
  Vector3 operator *(num t) {
    return Vector3(
      _x * t,
      _y * t,
      _z * t,
    );
  }

  /// Returns a new vector whose components are generated from the division
  /// of every component of this vector by `t`.
  ///
  /// Throws `ArgumentException` if the given number is 0.
  Vector3 operator /(num t) {
    if (t == 0) {
      throw ArgumentError("Division by zero not supoorted");
    }
    return this * (1 / t);
  }

  /// Returns a new vector generated from the product of every component
  /// of this vector with the corresponding component of `other`.
  Vector3 multiplyBy(Vector3 other) {
    return Vector3(
      x * other.x,
      y * other.y,
      z * other.z,
    );
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
}

/// Point3 type: represents a point a three-dimensional space.
/// A point in space can be represented as a vector having its
/// tail at (0, 0, 0) and its tip at the corresponding point.
typedef Point3 = Vector3;
