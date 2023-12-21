import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sit/settings/settings.dart';

class SitHttpOverrides extends HttpOverrides {
  SitHttpOverrides();

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (cert, host, port) => true;
    client.findProxy = (url) {
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
    http: _buildProxyForType(ProxyType.http, isSchoolLanRequired),
    https: _buildProxyForType(ProxyType.https, isSchoolLanRequired),
    all: _buildProxyForType(ProxyType.all, isSchoolLanRequired),
  );
}

String? _buildProxyForType(ProxyType type, bool isSchoolLanRequired) {
  final profile = Settings.proxy.resolve(type);
  final address = profile.address;
  if (address == null) return null;
  if (!profile.enabled) return null;
  if (profile.proxyMode == ProxyMode.global && !isSchoolLanRequired) return null;
  return address;
}

bool _isSchoolNetwork(String host) {
  if (host == 'jwxt.sit.edu.cn') {
    // 教务系统
    return true;
  } else if (host == 'sc.sit.edu.cn') {
    // Second class
    return true;
  } else if (host == 'card.sit.edu.cn') {
    // 校园卡
    return true;
  } else if (host == 'myportal.sit.edu.cn') {
    // OA
    return true;
  } else if (host == '210.35.66.106') {
    // Library
    return true;
  } else if (host == '210.35.98.178') {
    // TODO: what's this
    // 门
    return true;
  }
  return false;
}

bool _isSchoolLanRequired(String host) {
  if (host == 'jwxt.sit.edu.cn') {
    // 教务系统
    return true;
  } else if (host == 'sc.sit.edu.cn') {
    // Second class
    return true;
  } else if (host == 'card.sit.edu.cn') {
    // 校园卡
    return true;
  }
  if (host == '210.35.66.106') {
    // Library
    return true;
  } else if (host == '210.35.98.178') {
    // TODO: what's this
    // 门
    return true;
  }
  return false;
}
