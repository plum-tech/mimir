import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension BuildContextRiverpodX on BuildContext {
  ProviderContainer riverpod({
    bool listen = true,
  }) =>
      ProviderScope.containerOf(
        this,
        listen: listen,
      );
}
