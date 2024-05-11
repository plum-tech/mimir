import 'package:meta/meta.dart';

import 'impl.dart';

@immutable
class List2DView<T> with Iterable<T> implements List2D<T> {
  final List2D<T> parent;
  final int rowStart;
  final int columnStart;
  @override
  final int rows;
  @override
  final int columns;

  /// For example:
  /// [parent] has 9 rows and 9 columns.
  /// The view starts at row 4, column 5.
  /// The [rows] should be in [4, ]
  List2DView({
    required this.parent,
    required this.rowStart,
    required this.columnStart,
    required this.rows,
    required this.columns,
  }) {
    assert(rowStart >= 0);
    assert(columnStart >= 0);
    assert(rows <= parent.rows - rowStart);
    assert(columns <= parent.columns - columnStart);
  }

  void _checkRange(int row, int column) {
    if (!(0 <= row && row <= rows)) {
      throw RangeError.range(row, 0, rows);
    }
    if (!(0 <= column && column <= columns)) {
      throw RangeError.range(column, 0, columns);
    }
  }

  @override
  T get(int row, int column) {
    _checkRange(row, column);
    return parent.get(rowStart + row, columnStart + column);
  }

  @override
  void set(int row, int column, T value) {
    _checkRange(row, column);
    parent.set(rowStart + row, columnStart + column, value);
  }

  @override
  Iterator<T> get iterator => List2DViewIterator(this);

  @override
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) {
    throw UnsupportedError("List2DView<$T> can't be encoded to json because it's based on another List2D");
  }

  @override
  List2D<E> map<E>(E Function(T e) toElement) {
    return List2D.generate(
      rows,
      columns,
      (row, column, index) => toElement(get(row, column)),
    );
  }
}

class List2DViewIterator<T> implements Iterator<T> {
  final List2DView<T> _view;
  int _row;
  int _column;
  T? _current;

  List2DViewIterator(List2DView<T> view)
      : _view = view,
        _row = 0,
        _column = 0;

  @override
  T get current => _current as T;

  @override
  @pragma("vm:prefer-inline")
  bool moveNext() {
    if (_row > _view.rows && _column > _view.columns) {
      _current = null;
      return false;
    }
    _current = _view.get(_row, _column);
    _column++;
    if (_column > _view.columns) {
      _column = 0;
      _row++;
    }
    return true;
  }
}
