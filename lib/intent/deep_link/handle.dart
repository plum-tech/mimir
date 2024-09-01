import 'package:flutter/widgets.dart';
import 'package:mimir/intent/deep_link/protocol.dart';
import 'package:mimir/r.dart';
import 'package:mimir/utils/error.dart';

import 'registry.dart';

enum DeepLinkHandleResult {
  success,
  unhandled,
  unrelatedScheme,
  invalidFormat;
}

bool _allowedScheme(String scheme) {
  return scheme != R.scheme &&
      // for backward compatibility
      scheme != "sitlife" &&
      scheme != "life.mysit";
}

Future<DeepLinkHandleResult> onHandleDeepLinkString({
  required BuildContext context,
  required String deepLink,
}) async {
  final deepLinkUri = Uri.tryParse(deepLink);
  if (deepLinkUri == null) return DeepLinkHandleResult.invalidFormat;
  return onHandleDeepLink(context: context, deepLink: deepLinkUri);
}

DeepLinkHandlerProtocol? getFirstDeepLinkHandler({
  required Uri deepLink,
}) {
  if (_allowedScheme(deepLink.scheme)) return null;
  assert(() {
    return DeepLinkHandlers.all.where((handler) => handler.match(deepLink)).length <= 1;
  }(),
      "Matched multiple handlers: ${DeepLinkHandlers.all.where((handler) => handler.match(deepLink)).toList()}");
  for (final handler in DeepLinkHandlers.all) {
    if (handler.match(deepLink)) {
      return handler;
    }
  }
  return null;
}

Future<DeepLinkHandleResult> onHandleDeepLink({
  required BuildContext context,
  required Uri deepLink,
}) async {
  if (_allowedScheme(deepLink.scheme)) return DeepLinkHandleResult.unrelatedScheme;
  final handler = getFirstDeepLinkHandler(deepLink: deepLink);
  if (handler == null) return DeepLinkHandleResult.unhandled;
  try {
    await handler.onHandle(context: context, data: deepLink);
    return DeepLinkHandleResult.success;
  } catch (error, stackTrace) {
    debugPrintError(error, stackTrace);
    return DeepLinkHandleResult.invalidFormat;
  }
}
