import 'package:flutter/widgets.dart';
import 'package:sit/qrcode/deep_link.dart';
import 'package:sit/r.dart';

enum DeepLinkHandleResult {
  success,
  unhandled,
  unrecognized,
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
  for (final handler in DeepLinkHandlerProtocol.all) {
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
  if (_allowedScheme(deepLink.scheme)) return DeepLinkHandleResult.unrecognized;
  for (final handler in DeepLinkHandlerProtocol.all) {
    if (handler.match(deepLink)) {
      await handler.onHandle(context: context, qrCodeData: deepLink);
      return DeepLinkHandleResult.success;
    }
  }
  return DeepLinkHandleResult.unhandled;
}
