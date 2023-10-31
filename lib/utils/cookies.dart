import 'package:cookie_jar/cookie_jar.dart';
import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'logger.dart';

extension WebViewCookieJarX on CookieJar {
  Future<List<WebViewCookie>> loadAsWebViewCookie(Uri uri) async {
    final cookies = await loadForRequest(uri);
    return cookies.map((cookie) {
      return cookie.toWebviewCooke(uri);
    }).toList();
  }
}

extension WebViewCookieX on Cookie {
  WebViewCookie toWebviewCooke(Uri uri) {
    return WebViewCookie(
      name: name,
      value: value,
      domain: domain ?? uri.host,
    );
  }
}
