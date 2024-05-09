class List2d<T> {
  final List<T> _internal;
  final int rows;
  final int columns;

  const List2d(
    this.rows,
    this.columns,
    this._internal,
  );

  factory List2d.gen(int rows, int columns, T Function(int row, int column) generator) {
    return List2d(
      rows,
      columns,
      List.generate(
        rows * columns,
        (index) => generator(
          rowOf(index, columns),
          columnOf(index, columns),
        ),
      ),
    );
  }

  static int rowOf(int index, int columns) {
    return index ~/ columns;
  }

  static int columnOf(int index, int columns) {
    return index % columns;
  }

  static int indexOf(int row, int column, int columns) {
    return row * columns + column;
  }

  operator []((int, int) index) {
    return get(index.$1, index.$2);
  }

  operator []=((int, int) index, T value) {
    return set(index.$1, index.$2, value);
  }

  T get(int row, int column) {
    return _internal[indexOf(row, column, columns)];
  }

  void set(int row, int column, T value) {
    _internal[indexOf(row, column, columns)] = value;
  }

  List2d<T> clone() {
    return List2d(
      rows,
      columns,
      List.of(_internal),
    );
  }
}
