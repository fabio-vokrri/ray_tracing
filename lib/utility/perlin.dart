import 'package:ray_tracing/extensions/permute.dart';
import 'package:ray_tracing/geometry/vector.dart';

class Perlin {
  final int _pointCount = 256;
  late List<int> _xPermutation, _yPermutation, _zPermutation;
  late List<Vector3> _randomVector;

  Perlin() {
    _randomVector = List<Vector3>.generate(
      _pointCount,
      (index) => Vector3.randomBetween(-1, 1).normalized,
    );
    _xPermutation = _generatePerlin();
    _yPermutation = _generatePerlin();
    _zPermutation = _generatePerlin();
  }

  double turbolence(Point3 point, {int depth = 7}) {
    double accumulator = 0;
    Point3 temporaryPoint = point;
    double weight = 1;

    for (int i = 0; i < depth; i++) {
      accumulator += weight * noise(temporaryPoint);
      weight *= 0.5;
      temporaryPoint *= 2;
    }

    return accumulator.abs();
  }

  double noise(Point3 point) {
    double u = point.x - (point.x).floor();
    double v = point.y - (point.y).floor();
    double w = point.z - (point.z).floor();

    int i = point.x.floor();
    int j = point.y.floor();
    int k = point.z.floor();

    var c = List.generate(
      2,
      (index) => List.generate(
        2,
        (index) => List.generate(
          2,
          (index) => Vector3.origin(),
        ),
      ),
    );

    for (int di = 0; di < 2; di++) {
      for (int dj = 0; dj < 2; dj++) {
        for (int dk = 0; dk < 2; dk++) {
          c[di][dj][dk] = _randomVector[//
              _xPermutation[(i + di) & 255] ^
                  _yPermutation[(j + dj) & 255] ^
                  _zPermutation[(k + dk) & 255] //
              ];
        }
      }
    }

    return _trilinearInterpolation(c, u, v, w);
  }

  List<int> _generatePerlin() {
    List<int> p = List.generate(_pointCount, (index) => index);
    p.permute(_pointCount);

    return p;
  }

  double _trilinearInterpolation(
    List<List<List<Vector3>>> c,
    double u,
    double v,
    double w,
  ) {
    double uu = u * u * (3 - 2 * u);
    double vv = v * v * (3 - 2 * v);
    double ww = w * w * (3 - 2 * w);

    double accumulator = 0;
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < 2; j++) {
        for (int k = 0; k < 2; k++) {
          Vector3 vWeight = Vector3(u - i, v - j, w - k);
          accumulator += (i * uu + (1 - i) * (1 - uu)) *
              (j * vv + (1 - j) * (1 - vv)) *
              (k * ww + (1 - k) * (1 - ww)) *
              c[i][j][k].dot(vWeight);
        }
      }
    }

    return accumulator;
  }
}
