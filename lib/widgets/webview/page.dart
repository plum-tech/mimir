import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimir/design/utils.dart';
import 'package:mimir/l10n/common.dart';
import 'package:mimir/launcher.dart';
import 'package:mimir/widgets/webview/injectable.dart';
import 'package:mimir/util/logger.dart';
import 'package:mimir/util/url_launcher.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MimirWebViewPage extends StatefulWidget {
  /// 初始的url
  final String initialUrl;

  /// 固定的标题名？若为null则自动获取目标页面标题
  final String? fixedTitle;

  /// js注入规则
  final List<Injection>? injectJsRules;

  /// 显示分享按钮(默认不显示)
  final bool showSharedButton;

  /// 显示刷新按钮(默认显示)
  final bool showRefreshButton;

  /// 显示在浏览器中打开按钮(默认不显示)
  final bool showLoadInBrowser;

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

  /// 如果不支持 WebView，是否显示浏览器打开按钮
  final bool showLaunchButtonIfUnsupported;

  /// 是否显示顶部进度条
  final bool showTopProgressIndicator;

  /// 自定义Action按钮
  final List<Widget>? otherActions;

  /// 夜间模式
  final bool followDarkMode;

  /// 注入cookies
  final List<WebViewCookie> initialCookies;

  const MimirWebViewPage({
    Key? key,
    required this.initialUrl,
    this.controller,
    this.fixedTitle,
    this.injectJsRules,
    this.floatingActionButton,
    this.showSharedButton = false,
    this.showRefreshButton = true,
    this.showLoadInBrowser = false,
    this.showTopProgressIndicator = true,
    this.userAgent,
    this.javaScriptChannels,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.showLaunchButtonIfUnsupported = true,
    this.otherActions,
    this.followDarkMode = false,
    this.initialCookies = const [],
  }) : super(key: key);

  @override
  State<MimirWebViewPage> createState() => _MimirWebViewPageState();
}

class _MimirWebViewPageState extends State<MimirWebViewPage> {
  WebViewController? controller;

  String title = const CommonI18n().untitled;
  int progress = 0;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? WebViewController();
  }

  void _onRefresh() async {
    await controller?.reload();
  }

  void _onShared() async {
    Log.info('分享页面: ${await controller?.currentUrl()}');
  }

  /// 构造进度条
  PreferredSizeWidget buildTopIndicator() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(3.0),
      child: LinearProgressIndicator(
        backgroundColor: Colors.white70.withOpacity(0),
        value: progress / 100,
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isDesktop) {
      Navigator.of(context).pop();
      GlobalLauncher.launch(widget.initialUrl);
      return Container();
    }
    final actions = <Widget>[
      if (widget.showSharedButton)
        IconButton(
          onPressed: _onShared,
          icon: const Icon(Icons.share),
        ),
      if (widget.showRefreshButton)
        IconButton(
          onPressed: _onRefresh,
          icon: const Icon(Icons.refresh),
        ),
      if (widget.showLoadInBrowser)
        IconButton(
          onPressed: () => launchUrlInBrowser(widget.initialUrl),
          icon: const Icon(Icons.open_in_browser),
        ),
      ...?widget.otherActions,
    ];
    final curTitle = widget.fixedTitle ?? title;
    return WillPopScope(
      onWillPop: () async {
        final canGoBack = await controller?.canGoBack() ?? false;
        if (canGoBack) controller?.goBack();
        // 如果wv能后退就不能退出路由
        return !canGoBack;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(curTitle),
          actions: actions,
          bottom: widget.showTopProgressIndicator ? buildTopIndicator() : null,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        floatingActionButton: widget.floatingActionButton,
        body: InjectableWebView(
          initialUrl: widget.initialUrl,
          controller: widget.controller,
          onPageStarted: widget.onPageFinished,
          onPageFinished: (url) async {
            if (!mounted) return;
            if (widget.fixedTitle == null) {
              final newTitle = await controller?.getTitle();
              if (newTitle != title && newTitle != null) {
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
          injections: [
            if (widget.followDarkMode && Theme.of(context).isDark)
              Injection(
                matcher: (url) => true,
                asyncJs: rootBundle.loadString('assets/webview/dark.js'),
                phrase: InjectionPhrase.onPageFinished,
              ),
            if (widget.injectJsRules != null) ...widget.injectJsRules!,
          ],
          javaScriptChannels: widget.javaScriptChannels,
          userAgent: widget.userAgent,
          showLaunchButtonIfUnsupported: widget.showLaunchButtonIfUnsupported,
          initialCookies: widget.initialCookies,
        ),
      ),
    );
  }
}
