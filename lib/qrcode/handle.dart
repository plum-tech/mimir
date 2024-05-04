import 'package:flutter/widgets.dart';
import 'package:sit/qrcode/protocol.dart';
import 'package:sit/r.dart';

enum QrCodeHandleResult {
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

Future<QrCodeHandleResult> onHandleDeepLinkString({
  required BuildContext context,
  required String deepLink,
}) async {
  final deepLinkUri = Uri.tryParse(deepLink);
  if (deepLinkUri == null) return QrCodeHandleResult.invalidFormat;
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

Future<QrCodeHandleResult> onHandleDeepLink({
  required BuildContext context,
  required Uri deepLink,
}) async {
  if (_allowedScheme(deepLink.scheme)) return QrCodeHandleResult.unrecognized;
  for (final handler in DeepLinkHandlerProtocol.all) {
    if (handler.match(deepLink)) {
      await handler.onHandle(context: context, qrCodeData: deepLink);
      return QrCodeHandleResult.success;
    }
  }
  return QrCodeHandleResult.unhandled;
}
