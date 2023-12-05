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
      final enableHttpProxy = Settings.httpProxy.enableHttpProxy;
      final globalMode = Settings.httpProxy.globalMode;
      final address = Settings.httpProxy.address;
      if (!enableHttpProxy) return 'DIRECT';
      final host = url.host;
      if (globalMode || _isSchoolNetwork(host)) {
        debugPrint('Accessing "$url" by proxy "$address"');
        return HttpClient.findProxyFromEnvironment(
          url,
          environment: {
            "http_proxy": address,
            "https_proxy": address,
          },
        );
      } else {
        debugPrint('Accessing "$url" bypass proxy');
        return 'DIRECT';
      }
    };
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
