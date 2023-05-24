import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mimir/util/logger.dart';
import 'package:mimir/util/rule.dart';
import 'package:mimir/util/url_launcher.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../unsupported_platform_launch.dart';

typedef JavaScriptMessageCallback = void Function(JavaScriptMessage msg);

enum InjectJsPhrase {
  onPageStarted,
  onPageFinished,
}

class InjectionRule {
  /// js注入的url匹配规则
  bool Function(String url) matcher;

  /// 若为空，则表示不注入
  String? js;

  /// 异步js字符串，若为空，则表示不注入
  Future<String?>? asyncJs;

  /// js注入时机
  InjectJsPhrase phrase;

  InjectionRule({
    required this.matcher,
    this.js,
    this.asyncJs,
    this.phrase = InjectJsPhrase.onPageFinished,
  });
}

class InjectableWebView extends StatefulWidget {
  final String? initialUrl;

  /// js注入规则，判定某个url需要注入何种js代码
  final List<InjectionRule>? injectionRules;

  /// 各种callback
  final WebViewCreatedCallback? onWebViewCreated;
  final PageStartedCallback? onPageStarted;
  final PageFinishedCallback? onPageFinished;
  final PageLoadingCallback? onProgress;

  /// 若该字段不为null，则表示使用post请求打开网页
  final Map<String, String>? postData;

  /// 注入cookies
  final List<WebViewCookie> initialCookies;

  /// 自定义 UA
  final String? userAgent;

  final JavaScriptMode mode;

  /// 暴露dart回调到js接口
  final Map<String, JavaScriptMessageCallback>? javaScriptChannels;

  /// 如果不支持webview，是否显示浏览器打开按钮
  final bool showLaunchButtonIfUnsupported;

  const InjectableWebView({
    Key? key,
    this.initialUrl,
    this.mode = JavaScriptMode.unrestricted,
    this.injectionRules,
    this.onWebViewCreated,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.userAgent,
    this.postData,
    this.initialCookies = const <WebViewCookie>[],
    this.javaScriptChannels,
    this.showLaunchButtonIfUnsupported = true,
  }) : super(key: key);

  @override
  State<InjectableWebView> createState() => _InjectableWebViewState();
}

class _InjectableWebViewState extends State<InjectableWebView> {
  late WebViewController _c;

  @override
  void initState() {
    super.initState();
    _c = WebViewController()..setJavaScriptMode(widget.mode);
    final channels = widget.javaScriptChannels;
    if (channels != null) {
      for (final entry in channels.entries) {
        _c.addJavaScriptChannel(entry.key, onMessageReceived: entry.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isDesktop) {
      return UnsupportedPlatformUrlLauncher(
        widget.initialUrl ?? '',
        showLaunchButton: widget.showLaunchButtonIfUnsupported,
      );
    } else {
      return buildWebView(widget.initialCookies);
    }
  }

  /// 获取该url匹配的所有注入项
  Iterable<InjectionRule> filterMatchedRule(String url, InjectJsPhrase injectTime) sync* {
    final rules = widget.injectionRules;
    if (rules != null) {
      for (final rule in rules) {
        if (rule.matcher(url) && rule.phrase == injectTime) {
          yield rule;
        }
      }
    }
  }

  /// 根据当前url筛选所有符合条件的js脚本，执行js注入
  Future<void> injectJs(InjectionRule injectJsRule) async {
    // 同步获取js代码
    if (injectJsRule.js != null) {
      Log.info('执行了js注入');
      await _c?.runJavaScript(injectJsRule.js!);
    }
    // 异步获取js代码
    if (injectJsRule.asyncJs != null) {
      String? js = await injectJsRule.asyncJs;
      if (js != null) {
        await _c?.runJavaScript(js);
      }
    }
  }

  String _buildFormHtml() {
    if (widget.postData == null) {
      return '';
    }
    return '''
    <form method="post" action="${widget.initialUrl}">
      ${widget.postData!.entries.map((e) => '''<input type="hidden" name="${e.key}" value="${e.value}">''').join('\n')}
      <button hidden type="submit">
    </form>
    <script>
      document.getElementsByTagName('form')[0].submit();
    </script>
    ''';
  }

  void onResourceError(WebResourceError error) {
    if (!(error.failingUrl?.startsWith('http') ?? true)) {
      launchUrlInBrowser(error.failingUrl!);
      _c?.goBack();
    }
  }

  Widget buildWebView(List<WebViewCookie> initialCookies) {
    return WebView(
      initialUrl: widget.initialUrl,
      initialCookies: initialCookies,
      javascriptMode: widget.javascriptMode,
      onWebViewCreated: (WebViewController webViewController) async {
        Log.info('WebView已创建，已获取到controller');
        _c = webViewController;
        if (widget.postData != null) {
          Log.info('通过post请求打开页面: ${widget.initialUrl}');
          await webViewController.loadHtmlString(_buildFormHtml());
        }
        widget.onWebViewCreated?.call(webViewController);
      },
      onWebResourceError: onResourceError,
      userAgent: widget.userAgent,
      onPageStarted: (String url) async {
        Log.info('开始加载url: $url');
        await Future.wait(filterMatchedRule(url, InjectJsPhrase.onPageStarted).map(injectJs));
        widget.onPageStarted?.call(url);
      },
      javascriptChannels: widget.javascriptChannels,
      onPageFinished: (String url) async {
        Log.info('url加载完毕: $url');
        await Future.wait(filterMatchedRule(url, InjectJsPhrase.onPageFinished).map(injectJs));
        widget.onPageFinished?.call(url);
      },
      onProgress: widget.onProgress,
    );
  }
}
