part of 'box.dart';

class NamedListCacheKey<T> extends CacheKey<List<T>> {
  final String name;

  NamedListCacheKey(super.box, this.name);

  @override
  List<T>? get value {
    final cache = box.get(name);
    if (cache is List<dynamic>) {
      return cache.cast<T>();
    } else {
      clear();
      return null;
    }
  }

  @override
  set value(List<T>? newValue) {
    if (newValue == null) {
      clear();
    } else {
      box.put(name, newValue);
      lastUpdate = DateTime.now();
    }
  }

  @override
  DateTime? get lastUpdate {
    return box.get("$name/$_lastUpdateKey");
  }

  @override
  set lastUpdate(DateTime? newValue) {
    box.put("$name/$_lastUpdateKey", newValue);
  }

  @override
  bool needRefresh({required Duration after}) {
    final last = lastUpdate;
    if (last == null) {
      return true;
    } else {
      return DateTime.now().difference(last) > after;
    }
  }
}

void _clearNamespace(Box box, String namespace) {
  for (final key in box.keys) {
    if (key is String && key.startsWith(namespace)) {
      box.delete(key);
    }
  }
}

class ListCacheNamespace<T> {
  final Box box;
  final String namespace;

  ListCacheNamespace(this.box, this.namespace);

  CacheKey<List<T>> make(String name) {
    return _NamespaceListCacheKey(box, namespace, name);
  }

  void clear() => _clearNamespace(box, namespace);
}

class ListCacheNamespace1<T, Arg1> {
  final Box box;
  final String namespace;
  final String Function(Arg1) maker;

  ListCacheNamespace1(this.box, this.namespace, this.maker);

  CacheKey<List<T>> make(Arg1 arg1) {
    return _NamespaceListCacheKey(box, namespace, maker(arg1));
  }

  void clear() => _clearNamespace(box, namespace);
}

class ListCacheNamespace2<T, Arg1, Arg2> {
  final Box box;
  final String namespace;
  final String Function(Arg1, Arg2) maker;

  ListCacheNamespace2(this.box, this.namespace, this.maker);

  CacheKey<List<T>> make(Arg1 arg1, Arg2 arg2) {
    return _NamespaceListCacheKey(box, namespace, maker(arg1, arg2));
  }

  void clear() => _clearNamespace(box, namespace);
}

class ListCacheNamespace3<T, Arg1, Arg2, Arg3> {
  final Box box;
  final String namespace;
  final String Function(Arg1, Arg2, Arg3) maker;

  ListCacheNamespace3(this.box, this.namespace, this.maker);

  CacheKey<List<T>> make(Arg1 arg1, Arg2 arg2, Arg3 arg3) {
    return _NamespaceListCacheKey(box, namespace, maker(arg1, arg2, arg3));
  }

  void clear() => _clearNamespace(box, namespace);
}

class _NamespaceListCacheKey<T> extends CacheKey<List<T>> {
  final String namespace;
  final String name;

  _NamespaceListCacheKey(super.box, this.namespace, this.name);

  @override
  List<T>? get value {
    final cache = box.get("$namespace/$name");
    if (cache is List<dynamic>) {
      return cache.cast<T>();
    } else {
      clear();
      return null;
    }
  }

  @override
  set value(List<T>? newValue) {
    if (newValue == null) {
      clear();
    } else {
      box.put("$namespace/$name", newValue);
      lastUpdate = DateTime.now();
    }
  }

  @override
  DateTime? get lastUpdate {
    return box.get("$namespace/$name/$_lastUpdateKey");
  }

  @override
  set lastUpdate(DateTime? newValue) {
    box.put("$namespace/$name/$_lastUpdateKey", newValue);
  }

  @override
  bool needRefresh({required Duration after}) {
    final last = lastUpdate;
    if (last == null) {
      return true;
    } else {
      return DateTime.now().difference(last) > after;
    }
  }
}
