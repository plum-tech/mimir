import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';

final _log = Logger();

extension BoxX on Box {
  T? safeGet<T>(dynamic key, {T? defaultValue}) {
    final value = get(key, defaultValue: defaultValue);
    if (value == null) return null;
    if (value is! T) {
      _log.e("[Box $name] $key is in ${value.runtimeType} but $T is expected.");
      return null;
    }
    return value;
  }

  Future<void> safePut<T>(dynamic key, T? value) async {
    await put(key, value);
  }
}

class BoxFieldNotifier<T> extends StateNotifier<T?> {
  final Listenable listenable;
  final T? Function() get;
  final FutureOr<void> Function(T? v) set;

  BoxFieldNotifier(super._state, this.listenable, this.get, this.set) {
    listenable.addListener(_refresh);
  }

  void _refresh() {
    state = get();
  }

  @override
  void dispose() {
    listenable.removeListener(_refresh);
    super.dispose();
  }
}

class BoxFieldWithDefaultNotifier<T> extends StateNotifier<T> {
  final Listenable listenable;
  final T? Function() get;
  final T Function() getDefault;
  final FutureOr<void> Function(T? v) set;

  BoxFieldWithDefaultNotifier(super._state, this.listenable, this.get, this.set, this.getDefault) {
    listenable.addListener(_refresh);
  }

  void _refresh() {
    state = get() ?? getDefault();
  }

  @override
  void dispose() {
    listenable.removeListener(_refresh);
    super.dispose();
  }
}

class BoxChangeNotifier extends ChangeNotifier {
  final Listenable listenable;

  BoxChangeNotifier(this.listenable) {
    listenable.addListener(_refresh);
  }

  void _refresh() {
    notifyListeners();
  }

  @override
  void dispose() {
    listenable.removeListener(_refresh);
    super.dispose();
  }
}

class BoxFieldExistsChangeNotifier extends StateNotifier<bool> {
  final Listenable listenable;
  final bool Function() getExists;

  BoxFieldExistsChangeNotifier(super._state, this.listenable, this.getExists) {
    listenable.addListener(_refresh);
  }

  void _refresh() {
    state = getExists();
  }

  @override
  void dispose() {
    listenable.removeListener(_refresh);
    super.dispose();
  }
}

typedef BoxEventFilter = bool Function(BoxEvent event);

class BoxChangeStreamNotifier extends ChangeNotifier {
  final Stream<BoxEvent> stream;
  final BoxEventFilter? filter;
  late StreamSubscription _subscription;

  BoxChangeStreamNotifier(this.stream, this.filter) {
    _subscription = (filter != null ? stream.where(filter!) : stream).listen((event) {
      _refresh();
    });
  }

  void _refresh() {
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class BoxFieldStreamNotifier<T> extends StateNotifier<T?> {
  final Stream<BoxEvent> boxStream;
  final BoxEventFilter? filter;
  late StreamSubscription _subscription;

  BoxFieldStreamNotifier(super._state, this.boxStream, this.filter) {
    _subscription = (filter != null ? boxStream.where(filter!) : boxStream).listen((event) {
      final v = event.value;
      if (v is T?) {
        state = v;
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

extension BoxProviderX on Box {
  /// For generic class, like [List] or [Map], please specify the [get] for type conversion.
  AutoDisposeStateNotifierProvider<BoxFieldNotifier<T>, T?> provider<T>(
    dynamic key, {
    T? Function()? get,
    FutureOr<void> Function(T? v)? set,
  }) {
    return StateNotifierProvider.autoDispose<BoxFieldNotifier<T>, T?>((ref) {
      return BoxFieldNotifier(
        get?.call() ?? safeGet<T>(key),
        listenable(keys: [key]),
        () => get?.call() ?? safeGet<T>(key),
        (v) => set?.call(v) ?? safePut<T>(key, v),
      );
    });
  }

  /// For generic class, like [List] or [Map], please specify the [get] for type conversion.
  AutoDisposeStateNotifierProvider<BoxFieldWithDefaultNotifier<T>, T> providerWithDefault<T>(
    dynamic key,
    T Function() getDefault, {
    T? Function()? get,
    FutureOr<void> Function(T? v)? set,
  }) {
    return StateNotifierProvider.autoDispose<BoxFieldWithDefaultNotifier<T>, T>((ref) {
      return BoxFieldWithDefaultNotifier(
        get?.call() ?? safeGet<T>(key) ?? getDefault(),
        listenable(keys: [key]),
        () => get?.call() ?? safeGet<T>(key),
        (v) => set?.call(v) ?? safePut<T>(key, v),
        getDefault,
      );
    });
  }

  /// For generic class, like [List] or [Map], please specify the [get] for type conversion.
  AutoDisposeStateNotifierProviderFamily<BoxFieldNotifier<T>, T?, Arg> providerFamily<T, Arg>(
    dynamic Function(Arg arg) keyOf, {
    T? Function(Arg arg)? get,
    FutureOr<void> Function(Arg arg, T? v)? set,
  }) {
    return StateNotifierProvider.autoDispose.family<BoxFieldNotifier<T>, T?, Arg>((ref, arg) {
      return BoxFieldNotifier(
        get?.call(arg) ?? safeGet<T>(arg),
        listenable(keys: [keyOf(arg)]),
        () => get?.call(arg) ?? safeGet<T>(arg),
        (v) => set?.call(arg, v) ?? safePut<T>(arg, v),
      );
    });
  }

  AutoDisposeChangeNotifierProvider changeProvider(
    List<dynamic> keys,
  ) {
    return ChangeNotifierProvider.autoDispose((ref) {
      return BoxChangeNotifier(listenable(keys: keys));
    });
  }

  AutoDisposeStateNotifierProvider<BoxFieldExistsChangeNotifier, bool> existsChangeProvider(
    dynamic key,
  ) {
    return StateNotifierProvider.autoDispose((ref) {
      return BoxFieldExistsChangeNotifier(
        containsKey(key),
        listenable(keys: [key]),
        () => containsKey(key),
      );
    });
  }

  AutoDisposeStateNotifierProviderFamily<BoxFieldExistsChangeNotifier, bool, Arg> existsChangeProviderFamily<Arg>(
      dynamic Function(Arg arg) keyOf) {
    return StateNotifierProvider.autoDispose.family((ref, arg) {
      return BoxFieldExistsChangeNotifier(
        containsKey(keyOf(arg)),
        listenable(keys: [keyOf(arg)]),
        () => containsKey(keyOf(arg)),
      );
    });
  }

  AutoDisposeChangeNotifierProvider streamChangeProvider({
    BoxEventFilter? filter,
  }) {
    return ChangeNotifierProvider.autoDispose((ref) {
      return BoxChangeStreamNotifier(watch(), filter);
    });
  }

  AutoDisposeStateNotifierProvider<BoxFieldStreamNotifier<T>, T?> streamProvider<T>({
    required T? initial,
    BoxEventFilter? filter,
  }) {
    return StateNotifierProvider.autoDispose<BoxFieldStreamNotifier<T>, T?>((ref) {
      return BoxFieldStreamNotifier(initial, watch(), filter);
    });
  }

  ChangeNotifierProviderFamily<BoxChangeStreamNotifier, Arg> streamChangeProviderFamily<Arg>(
    bool Function(BoxEvent event, Arg arg) argFilter,
  ) {
    return ChangeNotifierProvider.family((ref, arg) {
      return BoxChangeStreamNotifier(watch(), (event) => argFilter(event, arg));
    });
  }
}
