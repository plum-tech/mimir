import 'dart:async';
import 'dart:typed_data';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:mimir/credential/storage/credential.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/global/cookie_init.dart';
import 'package:mimir/global/dio_init.dart';
import 'package:mimir/route.dart';
import 'package:mimir/session/sso/session.dart';

import '../widgets/captcha_box.dart';

class GlobalConfig {
  static String? httpProxy;
  static bool isTestEnv = false;
}

enum EventTypes {
  onRouteRefresh,
  onHomeRefresh,
  onHomeItemReorder,
  onCampusChange,
  onBackgroundChange,
  onJumpTodayTimetable,
}

/// 应用程序全局数据对象
class Global {
  static final eventBus = EventBus();

  static late CookieJar cookieJar;
  static late Dio dio;
  static late SsoSession ssoSession;

  // 是否正处于网络错误对话框
  static bool inSsoErrorDialog = false;

  static onSsoError(error, stacktrace) {
    if (error is DioException) {
      debugPrintStack(stackTrace: error.stackTrace);
    }
  }

  static Future<String?> onNeedInputCaptcha(Uint8List imageBytes) async {
    final context = $Key.currentContext!;
    return await context.show$Dialog$(
      dismissible: false,
      make: (context) => CaptchaBox(captchaData: imageBytes),
    );
  }

  static Future<void> init({
    required CredentialStorage credentials,
    bool? debugNetwork,
    required Box cookieBox,
  }) async {
    cookieJar = await CookieInit.init(box: cookieBox);
    dio = await DioInit.init(
      config: DioConfig()
        ..cookieJar = cookieJar
        ..httpProxy = GlobalConfig.httpProxy
        ..sendTimeout = const Duration(seconds: 6)
        ..receiveTimeout = const Duration(seconds: 6)
        ..connectTimeout = const Duration(seconds: 6),
      debug: debugNetwork,
    );
    ssoSession = SsoSession(dio: dio, cookieJar: cookieJar, onError: onSsoError, inputCaptcha: onNeedInputCaptcha);

    // 若本地存放了用户名与密码，那就惰性登录
    final oaCredential = credentials.oaCredentials;
    if (oaCredential != null) {
      // 惰性登录
      ssoSession.lazyLogin(oaCredential);
    }
  }
}
