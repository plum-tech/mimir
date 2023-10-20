import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sit/design/widgets/common.dart';
import 'package:sit/utils/logger.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

typedef JavaScriptMessageCallback = void Function(JavaScriptMessage msg);

class Injection {
  /// js注入的url匹配规则
  bool Function(String url) matcher;

  /// 若为空，则表示不注入
  String? js;

  /// 异步js字符串，若为空，则表示不注入
  Future<String?>? asyncJs;

  Injection({
    required this.matcher,
    this.js,
    this.asyncJs,
  });
}

class InjectableWebView extends StatefulWidget {
  final String initialUrl;
  final WebViewController? controller;

  /// JavaScript injection when page started.
  final List<Injection>? pageStartedInjections;

  /// JavaScript injection when page finished.
  final List<Injection>? pageFinishedInjections;

  /// hooks
  final void Function(String url)? onPageStarted;
  final void Function(String url)? onPageFinished;
  final void Function(int progress)? onProgress;

  /// 注入cookies
  final List<WebViewCookie>? initialCookies;

  /// 自定义 UA
  final String? userAgent;

  final JavaScriptMode mode;

  /// 暴露dart回调到js接口
  final Map<String, JavaScriptMessageCallback>? javaScriptChannels;

  const InjectableWebView({
    Key? key,
    required this.initialUrl,
    this.controller,
    this.mode = JavaScriptMode.unrestricted,
    this.pageStartedInjections,
    this.pageFinishedInjections,
    this.onPageStarted,
    this.onPageFinished,
    this.onProgress,
    this.userAgent,
    this.initialCookies,
    this.javaScriptChannels,
  }) : super(key: key);

  @override
  State<InjectableWebView> createState() => _InjectableWebViewState();
}

class _InjectableWebViewState extends State<InjectableWebView> {
  late WebViewController controller;
  final cookieManager = WebViewCookieManager();

  @override
  void initState() {
    super.initState();
    controller = (widget.controller ?? WebViewController())
      ..setJavaScriptMode(widget.mode)
      ..setUserAgent(widget.userAgent)
      ..setNavigationDelegate(NavigationDelegate(
        onWebResourceError: onResourceError,
        onPageStarted: (String url) async {
          Log.info('"$url" starts loading.');
          await Future.wait(widget.pageStartedInjections.matching(url).map(injectJs));
          widget.onPageStarted?.call(url);
        },
        onPageFinished: (String url) async {
          Log.info('"$url" loaded.');
          await Future.wait(widget.pageFinishedInjections.matching(url).map(injectJs));
          widget.onPageFinished?.call(url);
        },
        onProgress: widget.onProgress,
      ));
    final channels = widget.javaScriptChannels;
    if (channels != null) {
      for (final entry in channels.entries) {
        controller.addJavaScriptChannel(entry.key, onMessageReceived: entry.value);
      }
    }
    final cookies = widget.initialCookies;
    if (cookies != null) {
      for (final cookie in cookies) {
        cookieManager.setCookie(cookie);
      }
    }
    controller.loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    if (UniversalPlatform.isDesktop) {
      return LeavingBlank(icon: Icons.desktop_access_disabled_rounded);
    }
    return WebViewWidget(
      controller: controller,
    );
  }

  /// 根据当前url筛选所有符合条件的js脚本，执行js注入
  Future<void> injectJs(Injection injection) async {
    var injected = false;
    // 同步获取js代码
    if (injection.js != null) {
      injected = true;
      await controller.runJavaScript(injection.js!);
    }
    // 异步获取js代码
    if (injection.asyncJs != null) {
      injected = true;
      String? js = await injection.asyncJs;
      if (js != null) {
        await controller.runJavaScript(js);
      }
    }
    if (injected) {
      Log.info('JavaScript code was injected.');
    }
  }

  void onResourceError(WebResourceError error) {
    if (error.description.startsWith('http')) {
      launchUrlString(
        error.description,
        mode: LaunchMode.externalApplication,
      );
      controller.goBack();
    }
  }
}

extension _InjectionsX on List<Injection>? {
  /// 获取该url匹配的所有注入项
  Iterable<Injection> matching(String url) sync* {
    final injections = this;
    if (injections != null) {
      for (final injection in injections) {
        if (injection.matcher(url)) {
          yield injection;
        }
      }
    }
  }
}
