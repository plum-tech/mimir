import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

extension BoxX on Box {
  T? safeGet<T>(dynamic key, {T? defaultValue}) {
    final value = get(key, defaultValue: defaultValue);
    if (value is! T?) {
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

typedef BoxFieldNotifierProvider<T> = StateNotifierProvider<BoxFieldNotifier<T>, T?>;
extension BoxProviderX on Box {
  BoxFieldNotifierProvider<T> watchable<T>(dynamic key) {
    return BoxFieldNotifierProvider<T>((ref) {
      return BoxFieldNotifier(safeGet<T>(key), listenable(keys: [key]), () => safeGet<T>(key));
    });
  }
}
