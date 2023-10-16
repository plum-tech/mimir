import 'package:flutter/widgets.dart';
import 'package:sit/qrcode/protocol.dart';
import 'package:sit/r.dart';

enum QrCodeHandleResult {
  success,
  unhandled,
  unrecognized,
  invalidFormat;
}

Future<QrCodeHandleResult> onHandleQrCodeData({
  required BuildContext context,
  required String data,
}) async {
  final qrCodeData = Uri.tryParse(data);
  if (qrCodeData == null) return QrCodeHandleResult.invalidFormat;
  if (qrCodeData.scheme != R.baseScheme) return QrCodeHandleResult.unrecognized;
  for (final handler in DeepLinkHandlerProtocol.all) {
    if (handler.match(qrCodeData)) {
      await handler.onHandle(context: context, qrCodeData: qrCodeData);
      return QrCodeHandleResult.success;
    }
  }
  return QrCodeHandleResult.unhandled;
}
