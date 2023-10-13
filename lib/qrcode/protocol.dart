import 'package:flutter/cupertino.dart';
import 'package:sit/r.dart';
import 'package:sit/settings/page/proxy.dart';

/// convert any data to a URI with [R.baseScheme].
sealed class QrCodeHandlerProtocol {
  const QrCodeHandlerProtocol();

  bool match(Uri encoded);

  Future<void> onHandle({
    required BuildContext context,
    required Uri qrCodeData,
  });

  static const List<QrCodeHandlerProtocol> all = [
    HttpProxyQrCode(),
  ];
}

class HttpProxyQrCode implements QrCodeHandlerProtocol {
  static const path = "http-proxy";

  const HttpProxyQrCode();

  Uri encode(Uri httpProxy) => Uri(scheme: R.baseScheme, path: path, query: httpProxy.toString());

  Uri decode(Uri qrCodeData) => Uri.parse(qrCodeData.query);

  @override
  bool match(Uri encoded) {
    return encoded.path == path;
  }

  @override
  Future<void> onHandle({
    required BuildContext context,
    required Uri qrCodeData,
  }) async {
    final httpProxy = decode(qrCodeData);
    await onHttpProxyFromQrCode(
      context: context,
      httpProxy: httpProxy,
    );
  }
}
