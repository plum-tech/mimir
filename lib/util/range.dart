class RangeIterator<T extends num> implements Iterator<T> {
  Range range;
  num _current;

  RangeIterator(this.range) : _current = range.start;

  @override
  T get current => (_current - range.step) as T;

  @override
  bool moveNext() {
    if (range.end == null) {
      _current += range.step;
      return true;
    }
    if (_current < range.end!) {
      _current += range.step;
      return true;
    }
    return false;
  }
}

class Range<T extends num> extends Iterable<T> {
  T start;
  num? end;
  num step;

  Range(this.start, this.end, this.step);

  @override
  Iterator<T> get iterator => RangeIterator<T>(this);
}

Range<T> range<T extends num>(
  T arg1, [
  num? arg2,
  num? arg3,
]) {
  if (arg2 == null) {
    // 有一个参数，arg1代表长度
    return Range((arg1 is int ? 0 : 0.0) as T, arg1, 1);
  } else if (arg3 == null) {
    // 有两个参数
    return Range(arg1, arg2, 1);
  } else {
    // 有三个参数
    return Range(arg1, arg2, arg3);
  }
}
