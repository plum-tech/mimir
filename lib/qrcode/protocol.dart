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
    const ProxyDeepLink(),
    const TimetablePaletteDeepLink(),
  ];
}

class ProxyDeepLink extends DeepLinkHandlerProtocol {
  static const path = "proxy";

  const ProxyDeepLink();

  Uri encode(Uri httpProxy) => Uri(scheme: R.scheme, path: path, query: httpProxy.toString());

  ({Uri? http, Uri? https, Uri? all}) decode(Uri qrCodeData) {
    final param = qrCodeData.queryParameters;
    final http = param["http"];
    final https =param["https"];
    final all = param["all"];
    return (
    http: http == null ? ,
    );
  }

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
