import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

extension BoxX on Box {
  T? safeGet<T>(dynamic key, {T? defaultValue}) {
    final value = get(key, defaultValue: defaultValue);
    if (value == null) return null;
    if (value is! T) {
      debugPrint("[Box $name] $key is in ${value.runtimeType} but $T is expected.");
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

  BoxFieldNotifier(super._state, this.listenable, this.get) {
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

extension BoxProviderX on Box {
  /// For generic class, like [List] or [Map], please specify the [get] for type conversion.
  StateNotifierProvider<BoxFieldNotifier<T>, T?> watchable<T>(dynamic key, [T? Function()? get]) {
    return StateNotifierProvider<BoxFieldNotifier<T>, T?>((ref) {
      return BoxFieldNotifier(
        get?.call() ?? safeGet<T>(key),
        listenable(keys: [key]),
        () => get?.call() ?? safeGet<T>(key),
      );
    });
  }
}
