import 'package:cookie_jar/cookie_jar.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'logger.dart';

extension ConvertAsWebViewCookie on CookieJar {
  Future<List<WebViewCookie>> loadAsWebViewCookie(Uri uri) async {
    final cookies = await loadForRequest(uri);
    return cookies.map((cookie) {
      Log.info('获取cookie $cookie');
      return WebViewCookie(
        name: cookie.name,
        value: cookie.value,
        domain: cookie.domain ?? uri.host,
      );
    }).toList();
  }
}
