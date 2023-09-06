import 'package:flutter/material.dart';
import 'package:mimir/mini_apps/activity/using.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../init.dart';

const ywbUrl = 'https://xgfy.sit.edu.cn';

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
  List<WebViewCookie>? cookies;

  @override
  void initState() {
    super.initState();
    ApplicationInit.cookieJar.loadAsWebViewCookie(Uri.parse(ywbUrl)).then((value) {
      cookies = value;
      for (final cookie in value) {
        cookieManager.setCookie(cookie);
      }
      controller.loadRequest(Uri.parse(widget.url));
      setState(() {});
    }).onError((error, stackTrace) {});
  }

  @override
  Widget build(BuildContext context) {
    final cookies = this.cookies;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: cookies == null ? const CircularProgressIndicator() : buildWebPage(cookies),
    );
  }

  Widget buildWebPage(List<WebViewCookie> cookies) {
    return WebViewWidget(
      controller: controller,
    );
  }
}
