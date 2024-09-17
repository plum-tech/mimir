import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/animation/progress.dart';
import 'package:mimir/l10n/common.dart';
import 'package:mimir/utils/error.dart';
import 'package:rettulf/rettulf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'injectable.dart';

// TODO: remove this
const _kUserAgent =
    "Mozilla/5.0 (Linux; Android 10; HMA-AL00 Build/HUAWEIHMA-AL00; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36";

// TODO: Support proxy
class WebViewPage extends StatefulWidget {
  final bool appBar;

  /// 初始的url
  final String initialUrl;

  /// 固定的标题名？若为null则自动获取目标页面标题
  final String? fixedTitle;

  /// JavaScript injection when page started.
  final List<Injection>? pageStartedInjections;

  /// JavaScript injection when page finished.
  final List<Injection>? pageFinishedInjections;

  final bool enableShare;
  final bool enableRefresh;
  final bool enableOpenInBrowser;

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
    this.appBar = true,
    this.fixedTitle,
    this.pageStartedInjections,
    this.pageFinishedInjections,
    this.floatingActionButton,
    this.enableShare = true,
    this.enableRefresh = true,
    this.enableOpenInBrowser = true,
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
  double progress = 0;

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

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        try {
          final canGoBack = await controller.canGoBack();
          if (canGoBack) {
            await controller.goBack();
          } else {
            if (!context.mounted) return;
            return context.pop();
          }
        } catch (error, stackTrack) {
          debugPrintError(error, stackTrack);
        }
      },
      child: Scaffold(
        appBar: widget.appBar ? buildAppBar() : null,
        bottomNavigationBar: widget.bottomNavigationBar,
        floatingActionButton: progress < 1.0 ? AnimatedProgressCircle(value: progress) : null,
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
            setState(() => progress = value % 100 / 100);
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

  AppBar buildAppBar() {
    final curTitle = widget.fixedTitle ?? title ?? const CommonI18n().untitled;
    return AppBar(
      title: TextScroll(
        curTitle,
        velocity: const Velocity(pixelsPerSecond: Offset(40, 0)),
      ),
      actions: [
        if (widget.enableRefresh)
          PlatformIconButton(
            onPressed: _onRefresh,
            icon: Icon(context.icons.refresh),
          ),
        if (widget.enableShare)
          PlatformIconButton(
            onPressed: _onShared,
            icon: Icon(context.icons.share),
          ),
        if (widget.enableOpenInBrowser)
          PlatformIconButton(
            onPressed: () => launchUrlString(
              widget.initialUrl,
              mode: LaunchMode.externalApplication,
            ),
            icon: const Icon(Icons.open_in_browser),
          ),
        ...?widget.otherActions,
      ],
    );
  }
}
