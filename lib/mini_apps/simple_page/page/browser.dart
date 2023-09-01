import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../using.dart';

class BrowserPage extends StatelessWidget {
  final String initialUrl;
  final String? fixedTitle;

  /// false by default.
  final bool? showSharedButton;

  /// true by default.
  final bool? showRefreshButton;

  /// true by default.
  final bool? showOpenInBrowser;
  final String? userAgent;

  /// JS注入
  final String? javascript;

  /// 通过url获取js代码
  final String? javascriptUrl;

  const BrowserPage({
    Key? key,
    required this.initialUrl,
    this.fixedTitle,
    this.showSharedButton,
    this.showRefreshButton,
    this.showOpenInBrowser,
    this.userAgent,
    this.javascript,
    this.javascriptUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MimirWebViewPage(
      initialUrl: initialUrl,
      fixedTitle: fixedTitle,
      showSharedButton: showSharedButton ?? false,
      showRefreshButton: showRefreshButton ?? true,
      showOpenInBrowser: showOpenInBrowser ?? true,
      userAgent: userAgent,
      pageFinishedInjections: javascript == null
          ? null
          : [
              Injection(
                matcher: (url) => true,
                js: javascript,
                asyncJs: javascriptUrl == null
                    ? null
                    : Dio().get<String>(javascriptUrl!).asStream().map((e) => e.data).first,
              ),
            ],
    );
  }
}
