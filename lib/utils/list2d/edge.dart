import 'impl.dart';

enum Edge2D {
  /// at top-left corner
  topLeft(top: true, left: true),

  /// between top-left corner and top-right corner
  topCenter(top: true),

  /// at top-right corner
  topRight(top: true, right: true),

  /// at bottom-left corner
  bottomLeft(bottom: true, left: true),

  /// between bottom-left corner and bottom-right corner
  bottomCenter(bottom: true),

  /// at bottom-right corner
  bottomRight(right: true, bottom: true),

  /// between top-left corner and bottom-left corner
  centerLeft(left: true),

  /// between top-right corner and bottom-right corner
  centerRight(right: true),
  ;

  final bool top;
  final bool right;
  final bool left;
  final bool bottom;

  const Edge2D({
    this.top = false,
    this.right = false,
    this.left = false,
    this.bottom = false,
  });

  static Edge2D? fromLTRB({
    bool left = false,
    bool top = false,
    bool right = false,
    bool bottom = false,
  }) {
    if (top) {
      if (left) return topLeft;
      if (right) return topRight;
      return topCenter;
    } else if (bottom) {
      if (left) return bottomLeft;
      if (right) return bottomRight;
      return bottomCenter;
    } else if (left) {
      if (top) return topLeft;
      if (bottom) return bottomLeft;
      return centerLeft;
    } else if (right) {
      if (top) return topRight;
      if (bottom) return bottomRight;
      return centerRight;
    }
    return null;
  }
}

extension List2dX<T> on List2D<T> {
  bool onEdge(int row, int column) {
    return row == 0 || column == 0 || row == (rows - 1) || column == (columns - 1);
  }

  Edge2D? onWhichEdge(int row, int column) {
    final top = row == 0;
    final bottom = row == rows - 1;
    final left = column == 0;
    final right = column == columns - 1;
    return Edge2D.fromLTRB(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }
}
