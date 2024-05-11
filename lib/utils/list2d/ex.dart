import 'impl.dart';

extension List2dX<T> on List2D<T> {
  bool onEdge(int row, int column) {
    return row == 0 || column == 0 || row == (rows - 1) || column == (columns - 1);
  }
}
