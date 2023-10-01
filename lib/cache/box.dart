import 'package:hive/hive.dart';

part 'cache_key.dart';

part 'list_cache_key.dart';

abstract class HasBox<T> {
  Box<T> get box;
}

const _lastUpdateKey = ".LAST_UPDATE";

/// Please specify the concrete type parameter of a list.
/// Otherwise, the list will be dynamic and cause type issue when the Hive is read next time.
mixin CachedBox {
  Box get box;

  /// Create a named cache key.
  /// As a best practice, it will be used as a name2value map, such as Map<String,T>.
  // ignore: non_constant_identifier_names
  CacheKey<T> named<T>(String name) {
    return NamedCacheKey(box, name);
  }

  /// Create a cache namespace.
  /// As a best practice, it will be used as a map with multiple keys, such as Map<Foo,Map<Bar,T>>.
  // ignore: non_constant_identifier_names
  CacheNamespace1<T, Arg1> namespace<T, Arg1>(String namespace, String Function(Arg1) maker) {
    return CacheNamespace1(box, namespace, maker);
  }

  /// Create a cache namespace.
  /// As a best practice, it will be used as a map with multiple keys, such as Map<Foo,Map<Bar,T>>.
  // ignore: non_constant_identifier_names
  CacheNamespace2<T, Arg1, Arg2> namespace2<T, Arg1, Arg2>(String namespace, String Function(Arg1, Arg2) maker) {
    return CacheNamespace2(box, namespace, maker);
  }

  /// Create a named cache key.
  /// As a best practice, it will be used as a list, such as List<T>
  // ignore: non_constant_identifier_names
  CacheKey<List<T>> namedList<T>(String name) {
    return NamedListCacheKey(box, name);
  }

  /// Create a cache namespace.
  /// As a best practice, it will be used as a map with multiple keys but mapping to a list, such as Map<Foo,Map<Bar,List<T>>>.
  // ignore: non_constant_identifier_names
  ListCacheNamespace1<T, Arg1> listNamespace<T, Arg1>(String namespace, String Function(Arg1) maker) {
    return ListCacheNamespace1(box, namespace, maker);
  }

  /// Create a cache namespace.
  /// As a best practice, it will be used as a map with multiple keys but mapping to a list, such as Map<Foo,Map<Bar,List<T>>>.
  // ignore: non_constant_identifier_names
  ListCacheNamespace2<T, Arg1, Arg2> listNamespace2<T, Arg1, Arg2>(
      String namespace, String Function(Arg1, Arg2) maker) {
    return ListCacheNamespace2(box, namespace, maker);
  }

  /// Create a cache namespace.
  /// As a best practice, it will be used as a map with multiple keys but mapping to a list, such as Map<Foo,Map<Bar,List<T>>>.
  // ignore: non_constant_identifier_names
  ListCacheNamespace3<T, Arg1, Arg2, Arg3> listNamespace3<T, Arg1, Arg2, Arg3>(
      String namespace, String Function(Arg1, Arg2, Arg3) maker) {
    return ListCacheNamespace3(box, namespace, maker);
  }
}

abstract class CacheKey<T> {
  final Box box;

  const CacheKey(this.box);

  /// Return null if there's no cache for this.
  T? get value;

  /// If [newValue] is null, the cache will be delete.
  set value(T? newValue);

  /// Return null if there's no cache for this.
  DateTime? get lastUpdate;

  /// If [newValue] is null, the cache will be aborted.
  set lastUpdate(DateTime? newValue);

  bool needRefresh({required Duration after});

  void clear() {
    lastUpdate = null;
  }
}
