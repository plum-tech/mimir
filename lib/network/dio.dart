import 'dart:math';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/foundation.dart';
import 'package:sit/r.dart';
import 'package:universal_platform/universal_platform.dart';

final _rand = Random();

class DioInit {
  static Future<Dio> init({
    CookieJar? cookieJar,
    BaseOptions? config,
  }) async {
    final dio = Dio();
    if (!kIsWeb && cookieJar != null) {
      dio.interceptors.add(CookieManager(cookieJar));
    }
    if (kDebugMode && R.debugNetwork) {
      dio.interceptors.add(LogInterceptor());
    }
    if (kDebugMode && R.debugNetwork && R.poorNetworkSimulation) {
      dio.interceptors.add(PoorNetworkDioInterceptor());
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
    if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
      await FkUserAgent.init();
      dio.options.headers['User-Agent'] = FkUserAgent.webViewUserAgent ?? getRandomUa();
    } else {
      dio.options.headers['User-Agent'] = getRandomUa();
    }
  }
}

final _debugRequests = <RequestOptions>[];
final _debugResponses = <Response>[];

class PoorNetworkDioInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (kDebugMode) {
      _debugRequests.add(options);
    }
    final duration = Duration(milliseconds: _rand.nextInt(2000));
    debugPrint("Start to request ${options.uri}");
    await Future.delayed(duration);
    debugPrint("Delayed Request ${options.uri} $duration");
    handler.next(options);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (kDebugMode) {
      _debugResponses.add(response);
    }
    final duration = Duration(milliseconds: _rand.nextInt(2000));
    debugPrint("Start to response ${response.realUri}");
    await Future.delayed(duration);
    debugPrint("Delayed Response ${response.realUri} $duration");
    handler.next(response);
  }
}
