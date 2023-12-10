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
  static const path = "proxy/set";

  const ProxyDeepLink();

  Uri encode({
    required String? http,
    required String? https,
    required String? all,
  }) =>
      Uri(scheme: R.scheme, path: path, queryParameters: {
        if (http != null) "http": http,
        if (https != null) "https": https,
        if (all != null) "all": all,
      });

  ({Uri? http, Uri? https, Uri? all}) decode(Uri qrCodeData) {
    final param = qrCodeData.queryParameters;
    final http = param["http"];
    final https = param["https"];
    final all = param["all"];
    return (
      http: http == null ? null : Uri.tryParse(http),
      https: https == null ? null : Uri.tryParse(https),
      all: all == null ? null : Uri.tryParse(all),
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
    final (:http, :https, :all) = decode(qrCodeData);
    await onProxyFromQrCode(
      context: context,
      http: http,
      https: https,
      all: all,
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
