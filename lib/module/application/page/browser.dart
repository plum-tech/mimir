import 'package:flutter/material.dart';
import 'package:mimir/module/activity/using.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../init.dart';

const url = 'http://xgfy.sit.edu.cn/unifri-flow/';

class InAppViewPage extends StatefulWidget {
  final String title;
  final String url;

  const InAppViewPage({super.key, required this.title, required this.url});

  @override
  State<InAppViewPage> createState() => _InAppViewPageState();
}

class _InAppViewPageState extends State<InAppViewPage> {
  late WebViewController controller= WebViewController();
  late WebViewCookieManager cookieManager= WebViewCookieManager();

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
          for(final cookie in cookies){
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
