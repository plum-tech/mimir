import 'package:flutter/widgets.dart';
import 'package:mimir/agreements/entity/agreements.dart';
import 'package:mimir/intent/deep_link/protocol.dart';
import 'package:mimir/r.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/utils/error.dart';

import 'registry.dart';

enum DeepLinkHandleResult {
  success,
  unhandled,
  unrelatedScheme,
  invalidFormat;
}

bool _isSchemeAllowed(String scheme) {
  return scheme == R.scheme ||
      // for backward compatibility
      scheme == "sit-life" ||
      scheme == "life.mysit";
}

DeepLinkHandlerProtocol? _getFirstDeepLinkHandler({
  required Uri deepLink,
}) {
  if (!_isSchemeAllowed(deepLink.scheme)) return null;
  assert(() {
    return DeepLinkHandlers.all.where((handler) => handler.match(deepLink)).length <= 1;
  }(), "Matched multiple handlers: ${DeepLinkHandlers.all.where((handler) => handler.match(deepLink)).toList()}");
  for (final handler in DeepLinkHandlers.all) {
    if (handler.match(deepLink)) {
      return handler;
    }
  }
  return null;
}

bool canHandleDeepLink({
  required Uri deepLink,
}) {
  return _getFirstDeepLinkHandler(deepLink: deepLink) != null;
}

Future<DeepLinkHandleResult> onHandleDeepLink({
  required BuildContext context,
  required Uri deepLink,
}) async {
  final accepted = Settings.agreements.getBasicAcceptanceOf(AgreementVersion.current) ?? false;
  if (!accepted) return DeepLinkHandleResult.unhandled;

  if (!_isSchemeAllowed(deepLink.scheme)) return DeepLinkHandleResult.unrelatedScheme;
  final handler = _getFirstDeepLinkHandler(deepLink: deepLink);
  if (handler == null) return DeepLinkHandleResult.unhandled;
  try {
    await handler.onHandle(context: context, data: deepLink);
    return DeepLinkHandleResult.success;
  } catch (error, stackTrace) {
    debugPrintError(error, stackTrace);
    return DeepLinkHandleResult.invalidFormat;
  }
}
