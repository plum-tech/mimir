import 'package:flutter/cupertino.dart';
import 'package:sit/r.dart';
import 'package:sit/settings/page/proxy.dart';
import 'package:sit/timetable/entity/platte.dart';
import 'package:sit/timetable/page/p13n.dart';

/// convert any data to a URI with [R.scheme].
sealed class DeepLinkHandlerProtocol {
  const DeepLinkHandlerProtocol();

  bool match(Uri encoded);

  Future<void> onHandle({
    required BuildContext context,
    required Uri qrCodeData,
  });

  static final List<DeepLinkHandlerProtocol> all = [
    const HttpProxyDeepLink(),
    const TimetablePaletteDeepLink(),
  ];
}

class HttpProxyDeepLink extends DeepLinkHandlerProtocol {
  static const path = "http-proxy";

  const HttpProxyDeepLink();

  Uri encode(Uri httpProxy) => Uri(scheme: R.scheme, path: path, query: httpProxy.toString());

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

class TimetablePaletteDeepLink implements DeepLinkHandlerProtocol {
  static const path = "timetable-palette";

  const TimetablePaletteDeepLink();

  Uri encode(TimetablePalette palette) => Uri(scheme: R.scheme, path: path, query: palette.encodeBase64());

  TimetablePalette decode(Uri qrCodeData) => TimetablePalette.decodeFromBase64(qrCodeData.query);

  @override
  bool match(Uri encoded) {
    return encoded.path == path;
  }

  @override
  Future<void> onHandle({
    required BuildContext context,
    required Uri qrCodeData,
  }) async {
    final palette = decode(qrCodeData);
    await onTimetablePaletteFromQrCode(
      context: context,
      palette: palette,
    );
  }
}
