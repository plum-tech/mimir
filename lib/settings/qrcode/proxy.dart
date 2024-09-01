import 'package:flutter/widgets.dart';
import 'package:mimir/intent/link/deep_link.dart';
import 'package:mimir/intent/link/utils.dart';
import 'package:mimir/r.dart';
import 'package:mimir/settings/entity/proxy.dart';
import 'package:mimir/settings/page/proxy.dart';

class ProxyDeepLink extends DeepLinkHandlerProtocol {
  static const host = "proxy";
  static const path = "/set";

  const ProxyDeepLink();

  Uri encode({
    required ProxyProfile? http,
    required ProxyProfile? https,
    required ProxyProfile? all,
  }) =>
      Uri(scheme: R.scheme, host: host, path: path, queryParameters: {
        if (http != null) "http": encodeBytesForUrl(http.encodeByteList(), compress: false),
        if (https != null) "https": encodeBytesForUrl(https.encodeByteList(), compress: false),
        if (all != null) "all": encodeBytesForUrl(all.encodeByteList(), compress: false),
      });

  ({ProxyProfile? http, ProxyProfile? https, ProxyProfile? all}) decode(Uri qrCodeData) {
    final param = qrCodeData.queryParameters;
    final http = param["http"];
    final https = param["https"];
    final all = param["all"];

    return (
      http: http == null ? null : ProxyProfile.decodeFromByteList(decodeBytesFromUrl(http, compress: false)),
      https: https == null ? null : ProxyProfile.decodeFromByteList(decodeBytesFromUrl(https, compress: false)),
      all: all == null ? null : ProxyProfile.decodeFromByteList(decodeBytesFromUrl(all, compress: false)),
    );
  }

  @override
  bool match(Uri encoded) {
    return encoded.host == host && encoded.path == path;
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
