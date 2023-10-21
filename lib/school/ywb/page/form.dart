import 'package:flutter/material.dart';
import 'package:sit/init.dart';
import 'package:sit/utils/cookies.dart';
import 'package:webview_flutter/webview_flutter.dart';

const ywbUrl = 'https://xgfy.sit.edu.cn';

class YwbInAppViewPage extends StatefulWidget {
  final String title;
  final String url;

  const YwbInAppViewPage({super.key, required this.title, required this.url});

  @override
  State<YwbInAppViewPage> createState() => _YwbInAppViewPageState();
}

class _YwbInAppViewPageState extends State<YwbInAppViewPage> {
  final WebViewController controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
  final WebViewCookieManager cookieManager = WebViewCookieManager();
  List<WebViewCookie>? cookies;

  @override
  void initState() {
    super.initState();
    Init.cookieJar.loadAsWebViewCookie(Uri.parse(ywbUrl)).then((value) {
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
      body: cookies == null ? const CircularProgressIndicator.adaptive() : buildWebPage(cookies),
    );
  }

  Widget buildWebPage(List<WebViewCookie> cookies) {
    return WebViewWidget(
      controller: controller,
    );
  }
}
