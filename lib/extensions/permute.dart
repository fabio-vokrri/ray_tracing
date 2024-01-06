import 'dart:math';

extension Permute<T> on List<T> {
  /// permutes the first `n`-th elements of this list.
  void permute(int n) {
    for (var i = n - 1; i > 0; i--) {
      int target = Random().nextInt(i);
      T temp = this[i];
      this[i] = this[target];
      this[target] = temp;
    }
  }
}
