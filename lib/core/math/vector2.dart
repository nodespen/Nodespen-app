import 'dart:math' as math;
import 'dart:typed_data';

class Vector2 {
  final double x;
  final double y;

  const Vector2(this.x, this.y);
  const Vector2.zero() : x = 0, y = 0;
  const Vector2.one() : x = 1, y = 1;
  const Vector2.left() : x = -1, y = 0;
  const Vector2.right() : x = 1, y = 0;
  const Vector2.up() : x = 0, y = -1;
  const Vector2.down() : x = 0, y = 1;

  double get magnitude => math.sqrt(x * x + y * y);
  double get magnitudeSquared => x * x + y * y;
  Vector2 get normalized {
    final mag = magnitude;
    return mag > 0 ? Vector2(x / mag, y / mag) : Vector2.zero();
  }
  Vector2 get negated => Vector2(-x, -y);
  Vector2 get perpendicular => Vector2(-y, x);
  double get angle => math.atan2(y, x);
  Vector2 get abs => Vector2(x.abs(), y.abs());

  Vector2 operator +(Vector2 other) => Vector2(x + other.x, y + other.y);
  Vector2 operator -(Vector2 other) => Vector2(x - other.x, y - other.y);
  Vector2 operator *(double scalar) => Vector2(x * scalar, y * scalar);
  Vector2 operator -() => negated;
  double dot(Vector2 other) => x * other.x + y * other.y;
  double cross(Vector2 other) => x * other.y - y * other.x;

  double distanceTo(Vector2 other) => (this - other).magnitude;
  Vector2 lerp(Vector2 target, double t) {
    return Vector2(
      x + (target.x - x) * t,
      y + (target.y - y) * t,
    );
  }
  Vector2 rotate(double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return Vector2(x * cos - y * sin, x * sin + y * cos);
  }
  Vector2 transform(Matrix3 matrix) => matrix.transform(this);

  Float64List toFloat64() => Float64List.fromList([x, y]);
  @override bool operator ==(Object other) =>
    other is Vector2 && x == other.x && y == other.y;
  @override int get hashCode => Object.hash(x, y);
  @override String toString() => 'Vector2(${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)})';
}

class Matrix3 {
  final Float64List storage;
  Matrix3(List<double> values) : storage = Float64List.fromList(values);
  Matrix3.identity() : storage = Float64List.fromList([
    1, 0, 0,
    0, 1, 0,
    0, 0, 1,
  ]);
  Matrix3.translation(Vector2 t) : storage = Float64List.fromList([
    1, 0, t.x,
    0, 1, t.y,
    0, 0, 1,
  ]);
  Matrix3.scale(Vector2 s) : storage = Float64List.fromList([
    s.x, 0, 0,
    0, s.y, 0,
    0, 0, 1,
  ]);
  factory Matrix3.rotation(double angle) {
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return Matrix3([
      cos, -sin, 0,
      sin, cos, 0,
      0, 0, 1,
    ]);
  }

  Vector2 transform(Vector2 v) {
    return Vector2(
      storage[0] * v.x + storage[1] * v.y + storage[2],
      storage[3] * v.x + storage[4] * v.y + storage[5],
    );
  }
  Matrix3 operator *(Matrix3 other) {
    final result = Float64List(9);
    for (var i = 0; i < 3; i++) {
      for (var j = 0; j < 3; j++) {
        result[i * 3 + j] =
          storage[i * 3] * other.storage[j] +
          storage[i * 3 + 1] * other.storage[3 + j] +
          storage[i * 3 + 2] * other.storage[6 + j];
      }
    }
    return Matrix3(result.toList());
  }
  Matrix3 inverted() {
    final det = storage[0] * (storage[4] * storage[8] - storage[5] * storage[7])
        - storage[1] * (storage[3] * storage[8] - storage[5] * storage[6])
        + storage[2] * (storage[3] * storage[7] - storage[4] * storage[6]);
    if (det == 0) return Matrix3.identity();
    final invDet = 1.0 / det;
    return Matrix3([
      (storage[4] * storage[8] - storage[5] * storage[7]) * invDet,
      (storage[2] * storage[7] - storage[1] * storage[8]) * invDet,
      (storage[1] * storage[5] - storage[2] * storage[4]) * invDet,
      (storage[5] * storage[6] - storage[3] * storage[8]) * invDet,
      (storage[0] * storage[8] - storage[2] * storage[6]) * invDet,
      (storage[2] * storage[3] - storage[0] * storage[5]) * invDet,
      (storage[3] * storage[7] - storage[4] * storage[6]) * invDet,
      (storage[6] * storage[1] - storage[0] * storage[7]) * invDet,
      (storage[0] * storage[4] - storage[1] * storage[3]) * invDet,
    ]);
  }

  @override String toString() => 'Matrix3($storage)';
}
