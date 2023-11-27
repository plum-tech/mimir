import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sit/settings/settings.dart';

class ProxyInit {
  static Future<void> init() async {
    HttpOverrides.global = SitHttpOverrides(
      proxyAddress: Settings.httpProxy.address,
      enableHttpProxy: Settings.httpProxy.enableHttpProxy,
      globalMode: Settings.httpProxy.globalMode,
    );
  }
}

class SitHttpOverrides extends HttpOverrides {
  final String proxyAddress;
  final bool enableHttpProxy;
  final bool globalMode;

  SitHttpOverrides({
    required this.proxyAddress,
    required this.enableHttpProxy,
    required this.globalMode,
  });

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    // 设置证书检查
    client.badCertificateCallback = (cert, host, port) => _isSchoolNetwork(host);
    // 设置代理.
    if (enableHttpProxy && proxyAddress.isNotEmpty) {
      debugPrint('Using proxy "$proxyAddress"');
      client.findProxy = (url) {
        final host = url.host;
        if (globalMode || _isSchoolNetwork(host)) {
          debugPrint('Accessing "$url" by proxy "$proxyAddress"');
          return HttpClient.findProxyFromEnvironment(
            url,
            environment: {
              "http_proxy": proxyAddress,
              "https_proxy": proxyAddress,
            },
          );
        } else {
          debugPrint('Accessing "$url" bypass proxy');
          return 'DIRECT';
        }
      };
    }
    return client;
  }
}

// 使用代理访问的网站规则
bool _isSchoolNetwork(String host) {
  if (host == 'jwxt.sit.edu.cn') {
    // 教务系统
    return true;
  } else if (host == 'sc.sit.edu.cn') {
    // Second class
    return true;
  } else if (host == 'card.sit.edu.cn') {
    // TODO: what's this
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
