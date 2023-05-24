import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../using.dart';

class BrowserPage extends StatelessWidget {
  /// 初始的url
  final String initialUrl;

  /// 固定的标题名？若为null则自动获取目标页面标题
  final String? fixedTitle;

  /// 显示分享按钮(默认不显示)
  final bool? showSharedButton;

  /// 显示刷新按钮(默认显示)
  final bool? showRefreshButton;

  /// 显示在浏览器中打开按钮(默认不显示)
  final bool? showLoadInBrowser;

  /// 自定义 UA
  final String? userAgent;

  /// 如果不支持webview，是否显示浏览器打开按钮
  final bool? showLaunchButtonIfUnsupported;

  /// 是否显示顶部进度条
  final bool? showTopProgressIndicator;

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
    this.showLoadInBrowser,
    this.userAgent,
    this.showLaunchButtonIfUnsupported,
    this.showTopProgressIndicator,
    this.javascript,
    this.javascriptUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<InjectionRule> injectJsRules = [
      InjectionRule(
        matcher: (url) => true,
        js: javascript,
        asyncJs: javascriptUrl == null ? null : Dio().get<String>(javascriptUrl!).asStream().map((e) => e.data).first,
      ),
    ];

    return MimirWebViewPage(
      initialUrl: initialUrl,
      fixedTitle: fixedTitle,
      showSharedButton: showSharedButton ?? false,
      showRefreshButton: showRefreshButton ?? true,
      showLoadInBrowser: showLoadInBrowser ?? true,
      userAgent: userAgent,
      showLaunchButtonIfUnsupported: showLaunchButtonIfUnsupported ?? true,
      showTopProgressIndicator: showTopProgressIndicator ?? true,
      injectJsRules: javascript == null ? null : injectJsRules,
    );
  }
}
