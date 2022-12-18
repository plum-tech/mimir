import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mimir/user_widget/platform_widget.dart';
import 'package:mimir/util/logger.dart';
import 'package:mimir/util/rule.dart';
import 'package:mimir/util/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../unsupported_platform_launch.dart';

enum InjectJsTime {
  onPageStarted,
  onPageFinished,
}

class InjectJsRuleItem {
  /// js注入的url匹配规则
  Rule<String> rule;

  /// 若为空，则表示不注入
  String? javascript;

  /// 异步js字符串，若为空，则表示不注入
  Future<String?>? asyncJavascript;

  /// js注入时机
  InjectJsTime injectTime;

  InjectJsRuleItem({
    required this.rule,
    this.javascript,
    this.asyncJavascript,
    this.injectTime = InjectJsTime.onPageFinished,
  });
}

class MyWebView extends StatefulWidget {
  final String? initialUrl;

  /// js注入规则，判定某个url需要注入何种js代码
  final List<InjectJsRuleItem>? injectJsRules;

  /// 各种callback
  final WebViewCreatedCallback? onWebViewCreated;
  final PageStartedCallback? onPageStarted;
  final PageFinishedCallback? onPageFinished;
  final PageLoadingCallback? onProgress;

  final JavascriptMode javascriptMode;

  /// 若该字段不为null，则表示使用post请求打开网页
  final Map<String, String>? postData;

  /// 注入cookies
  final List<WebViewCookie> initialCookies;

  /// 自定义 UA
  final String? userAgent;

  /// 暴露dart回调到js接口
  final Set<JavascriptChannel>? javascriptChannels;

  /// 如果不支持webview，是否显示浏览器打开按钮
  final bool showLaunchButtonIfUnsupported;

  const MyWebView({
    Key? key,
    this.initialUrl,
    this.injectJsRules,
    this.onWebViewCreated,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.javascriptMode = JavascriptMode.unrestricted, // js支持默认启用
    this.userAgent,
    this.postData,
    this.initialCookies = const <WebViewCookie>[],
    this.javascriptChannels,
    this.showLaunchButtonIfUnsupported = true,
  }) : super(key: key);

  @override
  State<MyWebView> createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return MyPlatformWidget(
      desktopOrWebBuilder: (context) {
        return UnsupportedPlatformUrlLauncher(
          widget.initialUrl ?? '',
          showLaunchButton: widget.showLaunchButtonIfUnsupported,
        );
      },
      mobileBuilder: (context) {
        return buildWebView(widget.initialCookies);
      },
    );
  }

  /// 获取该url匹配的所有注入项
  Iterable<InjectJsRuleItem> getAllMatchJs(String url, InjectJsTime injectTime) {
    final rules = widget.injectJsRules
        ?.where((injectJsRule) => injectJsRule.rule.accept(url) && injectJsRule.injectTime == injectTime);
    return rules ?? [];
  }

  /// 根据当前url筛选所有符合条件的js脚本，执行js注入
  Future<void> injectJs(InjectJsRuleItem injectJsRule) async {
    // 同步获取js代码
    if (injectJsRule.javascript != null) {
      Log.info('执行了js注入');
      await _controller?.runJavascript(injectJsRule.javascript!);
    }
    // 异步获取js代码
    if (injectJsRule.asyncJavascript != null) {
      String? js = await injectJsRule.asyncJavascript;
      if (js != null) {
        await _controller?.runJavascript(js);
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
      _controller?.goBack();
    }
  }

  Widget buildWebView(List<WebViewCookie> initialCookies) {
    return WebView(
      initialUrl: widget.initialUrl,
      initialCookies: initialCookies,
      javascriptMode: widget.javascriptMode,
      onWebViewCreated: (WebViewController webViewController) async {
        Log.info('WebView已创建，已获取到controller');
        _controller = webViewController;
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
        await Future.wait(getAllMatchJs(url, InjectJsTime.onPageStarted).map(injectJs));
        widget.onPageStarted?.call(url);
      },
      javascriptChannels: widget.javascriptChannels,
      onPageFinished: (String url) async {
        Log.info('url加载完毕: $url');
        await Future.wait(getAllMatchJs(url, InjectJsTime.onPageFinished).map(injectJs));
        widget.onPageFinished?.call(url);
      },
      onProgress: widget.onProgress,
    );
  }
}
