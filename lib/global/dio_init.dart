import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/services.dart';
import 'package:mimir/r.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/utils/logger.dart';

final _rand = Random();

class DioConfig {
  String? httpProxy;
  bool allowBadCertificate = true;
  CookieJar cookieJar = DefaultCookieJar();
  Duration? connectTimeout;
  Duration? sendTimeout;
  Duration? receiveTimeout;
}

/// 用于初始化Dio,全局只有一份dio对象
class DioInit {
  /// 初始化SessionPool
  static Future<Dio> init({required DioConfig config, bool? debug}) async {
    // dio初始化完成后，才能初始化 UA
    final dio = _initDioInstance(config: config, debug: debug);
    await _initUserAgentString(dio: dio);

    return dio;
  }

  static Dio _initDioInstance({required DioConfig config, bool? debug}) {
    // 设置 HTTP 代理
    HttpOverrides.global = MimirHttpOverrides(config: config, debug: debug);

    Dio dio = Dio();
    // 添加拦截器
    dio.interceptors.add(CookieManager(config.cookieJar));

    // 设置默认超时时间
    dio.options = dio.options.copyWith(
      connectTimeout: config.connectTimeout,
      sendTimeout: config.sendTimeout,
      receiveTimeout: config.receiveTimeout,
    );
    return dio;
  }

  static String getRandomUa() {
    return R.userAgents[_rand.nextInt(R.userAgents.length)].trim();
  }

  static Future<void> _initUserAgentString({
    required Dio dio,
  }) async {
    try {
      // 如果非IOS/Android，则该函数将抛异常
      await FkUserAgent.init();
      // 更新 dio 设置的 user-agent 字符串
      dio.options.headers['User-Agent'] = FkUserAgent.webViewUserAgent ?? getRandomUa();
    } catch (e) {
      // Desktop端将进入该异常
      dio.options.headers['User-Agent'] = getRandomUa();
    }
  }
}

// 使用代理访问的网站规则
bool _proxyFilter(String host) {
  if (host == 'jwxt.sit.edu.cn') {
    return true;
  } else if (host == 'sc.sit.edu.cn') {
    return true;
  } else if (host == 'card.sit.edu.cn') {
    return true;
  } else if (host == 'myportal.sit.edu.cn') {
    return true;
  } else if (host == '210.35.66.106') {
    // 图书
    return true;
  } else if (host == '210.35.98.178') {
    // 门
    return true;
  }
  return false;
}

class MimirHttpOverrides extends HttpOverrides {
  final DioConfig config;
  final bool? debug;

  MimirHttpOverrides({required this.config, this.debug});

  String getProxyPolicyByUrl(Uri url, String httpProxy) {
    final host = url.host;
    if ((debug ?? false) || _proxyFilter(host)) {
      Log.info('使用代理访问 $url');
      return 'PROXY $httpProxy';
    } else {
      Log.info('直连访问 $url');
      return 'DIRECT';
    }
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);

    // 设置证书检查
    if (config.allowBadCertificate || Settings.useHttpProxy || config.httpProxy != null) {
      client.badCertificateCallback = (cert, host, port) => true;
    }

    // 设置代理. 优先使用代码中的设置, 便于调试.
    if (config.httpProxy != null) {
      // 判断测试环境代理合法性
      // TODO: 检查代理格式
      if (config.httpProxy!.isNotEmpty) {
        // 可以
        Log.info('测试环境设置代理: ${config.httpProxy}');
        client.findProxy = (url) => getProxyPolicyByUrl(url, config.httpProxy!);
      } else {
        // 不行
        Log.info('测试环境代理服务器为空或不合法，将不使用代理服务器');
      }
    } else if (Settings.useHttpProxy && Settings.httpProxy.isNotEmpty) {
      Log.info('线上设置代理: ${config.httpProxy}');
      client.findProxy = (url) => getProxyPolicyByUrl(url, Settings.httpProxy);
    }
    return client;
  }
}
