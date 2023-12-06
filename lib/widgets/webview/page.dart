import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sit/l10n/common.dart';
import 'package:sit/widgets/webview/injectable.dart';
import 'package:rettulf/rettulf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

// TODO: remove this
const _kUserAgent =
    "Mozilla/5.0 (Linux; Android 10; HMA-AL00 Build/HUAWEIHMA-AL00; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36";

// TODO: Support proxy
class WebViewPage extends StatefulWidget {
  /// 初始的url
  final String initialUrl;

  /// 固定的标题名？若为null则自动获取目标页面标题
  final String? fixedTitle;

  /// JavaScript injection when page started.
  final List<Injection>? pageStartedInjections;

  /// JavaScript injection when page finished.
  final List<Injection>? pageFinishedInjections;

  /// 显示分享按钮(默认不显示)
  final bool showSharedButton;

  /// 显示刷新按钮(默认显示)
  final bool showRefreshButton;

  /// 显示在浏览器中打开按钮(默认不显示)
  final bool showOpenInBrowser;

  /// 浮动按钮控件
  final Widget? floatingActionButton;

  /// 自定义 UA
  final String? userAgent;

  final WebViewController? controller;

  /// hooks
  final void Function(String url)? onPageStarted;
  final void Function(String url)? onPageFinished;
  final void Function(int progress)? onProgress;

  final Map<String, JavaScriptMessageCallback>? javaScriptChannels;

  /// 自定义Action按钮
  final List<Widget>? otherActions;

  /// 夜间模式
  final bool followDarkMode;

  /// 注入cookies
  final List<WebViewCookie> initialCookies;
  final Widget? bottomNavigationBar;

  const WebViewPage({
    super.key,
    required this.initialUrl,
    this.controller,
    this.fixedTitle,
    this.pageStartedInjections,
    this.pageFinishedInjections,
    this.floatingActionButton,
    this.showSharedButton = true,
    this.showRefreshButton = true,
    this.showOpenInBrowser = true,
    this.userAgent = _kUserAgent,
    this.javaScriptChannels,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.otherActions,
    this.followDarkMode = false,
    this.initialCookies = const [],
    this.bottomNavigationBar,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController controller;
  late String? title = Uri.tryParse(widget.initialUrl)?.authority;
  int progress = 0;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? WebViewController();
  }

  void _onRefresh() async {
    await controller.reload();
  }

  void _onShared() async {
    final url = await controller.currentUrl();
    final uri = url == null ? Uri.tryParse(widget.initialUrl) : Uri.tryParse(url);
    if (uri != null) {
      Share.shareUri(uri);
    }
  }

  PreferredSizeWidget buildTopIndicator() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(4),
      child: LinearProgressIndicator(
        value: progress / 100,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final actions = <Widget>[
      if (widget.showRefreshButton)
        IconButton(
          onPressed: _onRefresh,
          icon: const Icon(Icons.refresh),
        ),
      if (widget.showSharedButton)
        IconButton(
          onPressed: _onShared,
          icon: const Icon(Icons.share),
        ),
      if (widget.showOpenInBrowser)
        IconButton(
          onPressed: () => launchUrlString(
            widget.initialUrl,
            mode: LaunchMode.externalApplication,
          ),
          icon: const Icon(Icons.open_in_browser),
        ),
      ...?widget.otherActions,
    ];
    final curTitle = widget.fixedTitle ?? title ?? const CommonI18n().untitled;
    return WillPopScope(
      onWillPop: () async {
        final canGoBack = await controller.canGoBack();
        if (canGoBack) await controller.goBack();
        // 如果wv能后退就不能退出路由
        return !canGoBack;
      },
      child: Scaffold(
        appBar: AppBar(
          title: TextScroll(curTitle),
          actions: actions,
          bottom: buildTopIndicator(),
        ),
        bottomNavigationBar: widget.bottomNavigationBar,
        floatingActionButton: widget.floatingActionButton,
        body: InjectableWebView(
          initialUrl: widget.initialUrl,
          controller: widget.controller,
          onPageStarted: widget.onPageFinished,
          onPageFinished: (url) async {
            if (!mounted) return;
            if (widget.fixedTitle == null) {
              final newTitle = await controller.getTitle();
              if (newTitle != title && newTitle != null && newTitle.isNotEmpty) {
                setState(() {
                  title = newTitle;
                });
              }
            }
            widget.onPageFinished?.call(url);
          },
          onProgress: (value) {
            if (!mounted) return;
            widget.onProgress?.call(value);
            setState(() => progress = value % 100);
          },
          pageStartedInjections: widget.pageStartedInjections,
          pageFinishedInjections: [
            if (widget.followDarkMode && context.isDarkMode)
              Injection(
                matcher: (url) => true,
                asyncJs: rootBundle.loadString('assets/webview/dark.js'),
              ),
            if (widget.pageFinishedInjections != null) ...widget.pageFinishedInjections!,
          ],
          javaScriptChannels: widget.javaScriptChannels,
          userAgent: widget.userAgent,
          initialCookies: widget.initialCookies,
        ),
      ),
    );
  }
}
