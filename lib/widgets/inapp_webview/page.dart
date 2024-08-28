import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

typedef NavigationRule = Future<bool> Function(WebUri uri);

NavigationRule limitOrigin(
  Uri originUri, {
  Future<void> Function(Uri uri)? onBlock,
}) {
  return (uri) async {
    if (uri.scheme != originUri.scheme || uri.host != originUri.host) {
      // cancel the request
      onBlock?.call(uri);
      return false;
    }
    return true;
  };
}

class InAppWebViewPage extends StatefulWidget {
  final WebUri initialUri;
  final NavigationRule? canNavigate;
  final bool enableShare;
  final bool enableOpenInBrowser;

  const InAppWebViewPage({
    super.key,
    required this.initialUri,
    this.canNavigate,
    this.enableShare = true,
    this.enableOpenInBrowser = true,
  });

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  final webViewKey = GlobalKey();

  InAppWebViewController? controller;
  late InAppWebViewSettings settings;
  bool canBack = false;
  bool canForward = false;

  PullToRefreshController? pullToRefreshController;
  var progress = 0.0;
  final $url = TextEditingController();

  @override
  void initState() {
    super.initState();

    settings = InAppWebViewSettings(
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      cacheMode: CacheMode.LOAD_CACHE_ELSE_NETWORK,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: true,
    );
    pullToRefreshController = kIsWeb
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                controller?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                controller?.loadUrl(urlRequest: URLRequest(url: await controller?.getUrl()));
              }
            },
          );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final controller = this.controller;
        if (controller == null) return context.pop();
        final canGoBack = await controller.canGoBack();
        if (canGoBack) {
          await controller.goBack();
        } else {
          if (!context.mounted) return;
          return context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: PlatformIconButton(
            icon: Icon(context.icons.close),
            onPressed: () {
              context.pop();
            },
          ),
          actions: buildNavigationButtons(),
        ),
        floatingActionButton: progress < 1.0 ? CircularProgressIndicator.adaptive(value: progress) : null,
        body: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: widget.initialUri),
          initialSettings: settings,
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) {
            this.controller = controller;
          },
          onLoadStart: (controller, url) {
            setState(() {
              $url.text = url.toString();
            });
          },
          // onScrollChanged: (controller, x, y) {
          //   print("${x},${y}");
          // },
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            final uri = navigationAction.request.url;
            if (uri == null) {
              return NavigationActionPolicy.CANCEL;
            }
            final canNavigateTo = widget.canNavigate;
            if (canNavigateTo == null || await canNavigateTo(uri)) {
              return NavigationActionPolicy.ALLOW;
            }
            // if (uri.scheme != R.forumUri.scheme || uri.host != R.forumUri.host) {
            //   if (await guardLaunchUrl(context, uri)) {
            //     // cancel the request
            //     return NavigationActionPolicy.CANCEL;
            //   }
            // }
            return NavigationActionPolicy.CANCEL;
          },
          onLoadStop: (controller, url) async {
            pullToRefreshController?.endRefreshing();
            setState(() {
              $url.text = url.toString();
            });
          },
          onReceivedError: (controller, request, error) {
            pullToRefreshController?.endRefreshing();
          },
          onProgressChanged: (controller, progress) {
            if (progress == 100) {
              pullToRefreshController?.endRefreshing();
            }
            setState(() {
              this.progress = progress / 100;
            });
          },
          onUpdateVisitedHistory: (controller, url, androidIsReload) async {
            setState(() {
              $url.text = url.toString();
            });
            await updateBackOrForward(controller);
          },
          onConsoleMessage: (controller, consoleMessage) {
            if (kDebugMode) {
              print(consoleMessage);
            }
          },
        ),
      ),
    );
  }

  Future<void> updateBackOrForward(InAppWebViewController controller) async {
    final canBack = await controller.canGoBack();
    final canForward = await controller.canGoForward();
    setState(() {
      this.canBack = canBack;
      this.canForward = canForward;
    });
  }

  List<Widget> buildNavigationButtons() {
    return [
      if (widget.enableShare)
        PlatformIconButton(
          onPressed: _onShared,
          icon: Icon(context.icons.share),
        ),
      if (widget.enableOpenInBrowser)
        PlatformIconButton(
          onPressed: _onOpenInBrowser,
          icon: const Icon(Icons.open_in_browser),
        ),
      PlatformIconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: !canBack
            ? null
            : () {
                controller?.goBack();
              },
      ),
      PlatformIconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          controller?.reload();
        },
      ),
      PlatformIconButton(
        icon: const Icon(Icons.arrow_forward),
        onPressed: !canForward
            ? null
            : () {
                controller?.goForward();
              },
      ),
    ];
  }

  void _onShared() async {
    final url = await controller?.getUrl();
    if (url == null) return;
    await Share.shareUri(url);
  }

  void _onOpenInBrowser() async {
    final url = await controller?.getUrl();
    if (url == null) return;
    await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );
  }
}
