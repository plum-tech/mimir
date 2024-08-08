import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/utils/guard_launch.dart';
import 'package:universal_platform/universal_platform.dart';

class InAppWebviewPage extends StatefulWidget {
  final WebUri initialUri;

  const InAppWebviewPage({
    super.key,
    required this.initialUri,
  });

  @override
  State<InAppWebviewPage> createState() => _InAppWebviewPageState();
}

class _InAppWebviewPageState extends State<InAppWebviewPage> {
  final webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  late InAppWebViewSettings settings;

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
    pullToRefreshController?.dispose();
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
          title: UniversalPlatform.isIOS ? null : buildNaviBar(),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: progress < 1.0 ? LinearProgressIndicator(value: progress) : const SizedBox.shrink(),
          ),
        ),
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
            return PermissionResponse(resources: request.resources, action: PermissionResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url!;

            if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
              if (await guardLaunchUrl(context, uri)) {
                // cancel the request
                return NavigationActionPolicy.CANCEL;
              }
            }

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
          onUpdateVisitedHistory: (controller, url, androidIsReload) {
            setState(() {
              $url.text = url.toString();
            });
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

  Widget buildNaviBar() {
    return OverflowBar(
      alignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          child: const Icon(Icons.arrow_back),
          onPressed: () {
            webViewController?.goBack();
          },
        ),
        ElevatedButton(
          child: const Icon(Icons.refresh),
          onPressed: () {
            webViewController?.reload();
          },
        ),
        ElevatedButton(
          child: const Icon(Icons.arrow_forward),
          onPressed: () {
            webViewController?.goForward();
          },
        ),
      ],
    );
  }
}
