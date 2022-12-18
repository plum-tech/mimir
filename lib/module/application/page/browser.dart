import 'package:flutter/material.dart';
import 'package:mimir/user_widget/future_builder.dart';
import 'package:mimir/util/cookie_util.dart';
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
      body: MyFutureBuilder<List<WebViewCookie>>(
        future: ApplicationInit.cookieJar.loadAsWebViewCookie(Uri.parse(url)),
        builder: (context, data) {
          return WebView(
            initialUrl: url,
            initialCookies: data,
          );
        },
      ),
    );
  }
}
