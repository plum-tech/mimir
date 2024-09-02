import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/intent/deep_link/protocol.dart';

class GoRouteDeepLink implements DeepLinkHandlerProtocol {
  static const host = "go";

  const GoRouteDeepLink();

  @override
  bool match(Uri encoded) {
    return encoded.host == host;
  }

  @override
  Future<void> onHandle({
    required BuildContext context,
    required Uri data,
  }) async {
    final target = data.path;
    if (target.isEmpty) return;
    await context.push(target);
  }
}
