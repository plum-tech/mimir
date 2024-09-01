import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/intent/deep_link/protocol.dart';

class GoRouteDeepLink implements DeepLinkHandlerProtocol {
  static const host = "go";

  const GoRouteDeepLink();

  String? decode(Uri data) {
    final params = data.queryParameters;
    final target = params.entries.firstWhereOrNull((p) => p.value.isEmpty)?.key;
    return target;
  }

  @override
  bool match(Uri encoded) {
    return encoded.host == host;
  }

  @override
  Future<void> onHandle({
    required BuildContext context,
    required Uri data,
  }) async {
    final target = decode(data);
    if (target == null) return;
    await context.push(target);
  }
}
