import 'dart:math';

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

  double get length => sqrt(squaredLength);
  double get squaredLength => _x * _x + _y * _y + _z * _z;

  Vector3 get normalized {
    if (length == 0) return this;
    return this / length;
  }

  Vector3 operator +(Vector3 other) {
    return Vector3(
      _x + other.x,
      _y + other.y,
      _z + other.z,
    );
  }

  Vector3 operator -(Vector3 other) {
    return Vector3(
      _x - other.x,
      _y - other.y,
      _z - other.z,
    );
  }

  Vector3 operator -() {
    return Vector3(
      -_x,
      -_y,
      -_z,
    );
  }

  Vector3 operator *(num t) {
    return Vector3(
      _x * t,
      _y * t,
      _z * t,
    );
  }

  Vector3 operator /(num t) {
    if (t == 0) {
      throw ArgumentError("Division by zero not supoorted");
    }
    return this * (1 / t);
  }

  Vector3 multiplyBy(Vector3 other) {
    return Vector3(
      x * other.x,
      y * other.y,
      z * other.z,
    );
  }

  Vector3 cross(Vector3 other) {
    return Vector3(
      _y * other.z - _z * other.y,
      _z * other.x - _x * other.z,
      _x * other.y - _y * other.x,
    );
  }

  double dot(Vector3 other) {
    return _x * other.x + _y * other.y + _z * other.z;
  }
}

typedef Point3 = Vector3;
