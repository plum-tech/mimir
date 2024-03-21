extension ListX<E> on List<E> {
  List<E> distinct({bool inplace = true}) {
    final ids = <E>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(x));
    return list;
  }

  List<E> distinctBy<Id>(Id Function(E element) id, {bool inplace = true}) {
    final ids = <Id>{};
    var list = inplace ? this : List<E>.from(this);
    list.retainWhere((x) => ids.add(id(x)));
    return list;
  }
}

extension IterableX<E> on Iterable<E> {
  E maxBy<T extends Comparable<T>>(T Function(E) valueOf) {
    final it = iterator;
    if (it.moveNext()) {
      final first = it.current;
      var tempMax = valueOf(first);
      var tempE = first;
      while (it.moveNext()) {
        final cur = it.current;
        final curValue = valueOf(cur);
        if (curValue.compareTo(tempMax) > 0) {
          tempMax = curValue;
          tempE = cur;
        }
      }
      return tempE;
    }
    throw Exception();
  }
}
