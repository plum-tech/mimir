import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/multiplatform.dart';

class InAppWebViewPage extends StatefulWidget {
  final WebUri initialUri;

  const InAppWebViewPage({
    super.key,
    required this.initialUri,
  });

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  final webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
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
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  void dispose() {
    webViewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final controller = webViewController;
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
          automaticallyImplyLeading: false,
          toolbarHeight: 4,
          title: progress < 1.0 ? LinearProgressIndicator(value: progress) : const SizedBox.shrink(),
        ),
        persistentFooterButtons: buildNavigationButtons(),
        body: InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: widget.initialUri),
          initialSettings: settings,
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) {
            webViewController = controller;
          },
          onLoadStart: (controller, url) {
            setState(() {
              $url.text = url.toString();
            });
          },
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT,
            );
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            // var uri = navigationAction.request.url!;
            // if (uri.scheme != R.forumUri.scheme || uri.host != R.forumUri.host) {
            //   if (await guardLaunchUrl(context, uri)) {
            //     // cancel the request
            //     return NavigationActionPolicy.CANCEL;
            //   }
            // }

            return NavigationActionPolicy.ALLOW;
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
      PlatformIconButton(
        icon: Icon(context.icons.close),
        onPressed: () {
          context.pop();
        },
      ),
      PlatformIconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: !canBack
            ? null
            : () {
                webViewController?.goBack();
              },
      ),
      PlatformIconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          webViewController?.reload();
        },
      ),
      PlatformIconButton(
        icon: const Icon(Icons.arrow_forward),
        onPressed: !canForward
            ? null
            : () {
                webViewController?.goForward();
              },
      ),
    ];
  }
}
