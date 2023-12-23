import 'dart:math';

import 'package:ray_tracing/const.dart';

extension ToGamma on double {
  double toGamma() {
    return pow(this, gamma).toDouble();
  }
}
