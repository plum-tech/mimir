import 'package:flutter/material.dart';
import 'package:mimir/mini_apps/activity/using.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../init.dart';

const url = 'http://ywb.sit.edu.cn';

class InAppViewPage extends StatefulWidget {
  final String title;
  final String url;

  const InAppViewPage({super.key, required this.title, required this.url});

  @override
  State<InAppViewPage> createState() => _InAppViewPageState();
}

class _InAppViewPageState extends State<InAppViewPage> {
  final WebViewController controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
  final WebViewCookieManager cookieManager = WebViewCookieManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PlaceholderFutureBuilder<List<WebViewCookie>>(
        future: ApplicationInit.cookieJar.loadAsWebViewCookie(Uri.parse(url)),
        builder: (context, cookies, state) {
          if (cookies == null) return Placeholders.loading();
          for (final cookie in cookies) {
            cookieManager.setCookie(cookie);
          }
          controller.loadRequest(Uri.parse(widget.url));
          return WebViewWidget(
            controller: controller,
          );
        },
      ),
    );
  }
}
