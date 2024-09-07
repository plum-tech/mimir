import 'package:flutter/material.dart';
import 'package:mimir/init.dart';
import 'package:webview_flutter/webview_flutter.dart';

const ywbUrl = 'https://ywb.sit.edu.cn';

class YwbInAppViewPage extends StatefulWidget {
  final String title;
  final String url;

  const YwbInAppViewPage({
    super.key,
    required this.title,
    required this.url,
  });

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
    // CookieManager.instance();
    // final cookies2 = openCookieBox(HiveInit.schoolCookies,R.ywbUri.host);
    _loadAsWebViewCookie().then((value) {
      cookies = value;
      for (final cookie in value) {
        cookieManager.setCookie(cookie);
      }
      controller.loadRequest(Uri.parse(widget.url));
      setState(() {});
    }).onError((error, stackTrace) {});
  }

  Future<List<WebViewCookie>> _loadAsWebViewCookie() async {
    final cookies = await Init.schoolCookieJar.loadForRequest(Uri.parse("https://ywb.sit.edu.cn/unifri-flow"));
    return cookies.map((cookie) {
      return WebViewCookie(
        name: cookie.name,
        value: cookie.value,
        domain: cookie.domain ?? "ywb.sit.edu.cn",
        path: cookie.path ?? "/unifri-flow",
      );
    }).toList();
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
