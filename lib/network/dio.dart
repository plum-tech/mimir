import 'dart:math';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/foundation.dart';
import 'package:sit/r.dart';

final _rand = Random();

/// 用于初始化Dio,全局只有一份dio对象
class DioInit {
  /// 初始化SessionPool
  static Future<Dio> init({
    required CookieJar cookieJar,
    BaseOptions? config,
  }) async {
    // 设置 HTTP 代理
    Dio dio = Dio();
    if (!kIsWeb) {
      dio.interceptors.add(CookieManager(cookieJar));
    }
    if (config != null) {
      dio.options = config;
    }
    await initUserAgentString(dio: dio);

    return dio;
  }

  static String getRandomUa() {
    return R.userAgentList[_rand.nextInt(R.userAgentList.length)].trim();
  }

  static Future<void> initUserAgentString({
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
