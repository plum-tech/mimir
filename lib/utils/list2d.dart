import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

part 'list2d.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class List2D<T> with Iterable<T> {
  @JsonKey(name: "internal", includeFromJson: true, includeToJson: true)
  final List<T> _internal;
  final int rows;
  final int columns;

  const List2D([
    this.rows = 0,
    this.columns = 0,
    this._internal = const [],
  ]);

  factory List2D.generate(int rows, int columns, T Function(int row, int column) generator) {
    return List2D(
      rows,
      columns,
      List.generate(
        rows * columns,
        (index) => generator(
          _rowOf(index, columns),
          _columnOf(index, columns),
        ),
      ),
    );
  }

  factory List2D.from(List<List<T>> list2d) {
    final rows = list2d.length;
    var columns = list2d.firstOrNull?.length ?? 0;
    for (final row in list2d) {
      assert(columns == row.length, "The length of each row should be the same.");
      columns = min(columns, row.length);
    }
    return List2D(
      rows,
      columns,
      List.generate(
        rows * columns,
        (index) => list2d[_rowOf(index, columns)][_columnOf(index, columns)],
      ),
    );
  }

  static int _rowOf(int index, int columns) {
    return index ~/ columns;
  }

  static int _columnOf(int index, int columns) {
    return index % columns;
  }

  static int _indexOf(int row, int column, int columns) {
    return row * columns + column;
  }

  operator []((int, int) index) {
    return get(index.$1, index.$2);
  }

  operator []=((int, int) index, T value) {
    return set(index.$1, index.$2, value);
  }

  T get(int row, int column) {
    if (_internal.isEmpty) {
      print(StackTrace.current);
    }
    return _internal[_indexOf(row, column, columns)];
  }

  void set(int row, int column, T value) {
    _internal[_indexOf(row, column, columns)] = value;
  }

  List2D<T> clone() {
    return List2D(
      rows,
      columns,
      List.of(_internal),
    );
  }

  @override
  Iterator<T> get iterator => _internal.iterator;

  @override
  List2D<E> map<E>(E Function(T e) toElement) {
    return List2D.generate(
      rows,
      columns,
      (row, column) => toElement(get(row, column)),
    );
  }

  Map<String, dynamic> toJson(
    Object? Function(T value) toJsonT,
  ) =>
      _$List2DToJson<T>(this, toJsonT);

  factory List2D.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$List2DFromJson<T>(json, fromJsonT);
}

extension List2dX<T> on List2D<T> {
  List2D<E> mapIndexed<E>(E Function(int row, int column, T e) toElement) {
    return List2D.generate(
      rows,
      columns,
      (row, column) => toElement(row, column, get(row, column)),
    );
  }
}
