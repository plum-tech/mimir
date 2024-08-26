import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mimir/r.dart';
import 'package:mimir/settings/entity/proxy.dart';
import 'package:mimir/settings/settings.dart';

class SitHttpOverrides extends HttpOverrides {
  SitHttpOverrides();

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (cert, host, port) => true;
    client.findProxy = (url) {
      if (kDebugMode) {
        print('Accessing "$url", captured by $SitHttpOverrides');
      }
      final host = url.host;
      final isSchoolLanRequired = _isSchoolLanRequired(host);
      final profiles = _buildProxy(isSchoolLanRequired);
      if (profiles.http == null && profiles.https == null && profiles.all == null) {
        return 'DIRECT';
      } else {
        final env = _toEnvMap(profiles);
        if (kDebugMode) {
          print("Access $url ${env.isEmpty ? "bypass proxy" : "by proxy $env"}");
        }
        // TODO: Socks proxy doesn't work with env
        return HttpClient.findProxyFromEnvironment(
          url,
          environment: env,
        );
      }
    };
    return client;
  }
}

Map<String, String> _toEnvMap(({String? http, String? https, String? all}) profiles) {
  final (:http, :https, :all) = profiles;
  return {
    if (http != null) "http_proxy": http,
    if (https != null) "https_proxy": https,
    if (all != null) "all_proxy": all,
  };
}

({String? http, String? https, String? all}) _buildProxy(bool isSchoolLanRequired) {
  return (
    http: _buildProxyForType(ProxyCat.http, isSchoolLanRequired),
    https: _buildProxyForType(ProxyCat.https, isSchoolLanRequired),
    all: _buildProxyForType(ProxyCat.all, isSchoolLanRequired),
  );
}

String? _buildProxyForType(ProxyCat cat, bool isSchoolLanRequired) {
  final profile = Settings.proxy.getProfileOf(cat);
  if (profile == null) return null;
  final address = profile.address;
  if (!profile.enabled) return null;
  if (profile.mode == ProxyMode.global || !isSchoolLanRequired) return null;
  return address.toString();
}

bool _isSchoolLanRequired(String host) {
  for (final uri in R.sitSchoolNetworkUriList) {
    if (host == uri.host) {
      return true;
    }
  }
  return false;
}
