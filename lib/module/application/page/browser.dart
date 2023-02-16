import 'package:flutter/material.dart';
import 'package:mimir/module/activity/using.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../init.dart';

const url = 'http://xgfy.sit.edu.cn/unifri-flow/';

class InAppViewPage extends StatelessWidget {
  final String title;
  final String url;

  const InAppViewPage({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: PlaceholderFutureBuilder<List<WebViewCookie>>(
        future: ApplicationInit.cookieJar.loadAsWebViewCookie(Uri.parse(url)),
        builder: (context, data, state) {
          if (data == null) return Placeholders.loading();
          return WebView(
            initialUrl: url,
            initialCookies: data,
          );
        },
      ),
    );
  }
}
