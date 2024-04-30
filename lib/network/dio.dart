import 'dart:math';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/foundation.dart';
import 'package:sit/r.dart';

final _rand = Random();

class DioInit {
  static Future<Dio> init({
    required CookieJar cookieJar,
    BaseOptions? config,
  }) async {
    final dio = Dio();
    if (!kIsWeb) {
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

final _debugRequests = <RequestOptions>[];
final _debugResponses = <Response>[];

class PoorNetworkDioInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if(kDebugMode){
      _debugRequests.add(options);
    }
    if(options.path == "http://sc.sit.edu.cn//public/init/index.action" || options.path == "http://sc.sit.edu.cn/public/init/index.action"){
      print("!!!!!!!!!!");
    }
    final duration = Duration(milliseconds: _rand.nextInt(2000));
    debugPrint("Start to request ${options.uri}");
    await Future.delayed(duration);
    debugPrint("Delayed Request ${options.uri} $duration");
    handler.next(options);
  }

  @override
  Future<void> onResponse(Response response, ResponseInterceptorHandler handler) async {
    if(kDebugMode){
      _debugResponses.add(response);
    }
    final duration = Duration(milliseconds: _rand.nextInt(2000));
    debugPrint("Start to response ${response.realUri}");
    await Future.delayed(duration);
    debugPrint("Delayed Response ${response.realUri} $duration");
    handler.next(response);
  }
}
