import 'dart:async';
import 'dart:typed_data';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mimir/app.dart';
import 'package:mimir/credential/dao/credential.dart';
import 'package:mimir/design/symbol.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/global/cookie_init.dart';
import 'package:mimir/global/dio_initializer.dart';
import 'package:mimir/route.dart';
import 'package:mimir/session/sso/sso_session.dart';
import 'package:mimir/storage/dao/auth.dart';

import 'i18n.dart';
import '../widgets/captcha_box.dart';

class GlobalConfig {
  static String? httpProxy;
  static bool isTestEnv = false;
}

enum EventTypes {
  onRouteRefresh,
  onHomeRefresh,
  onHomeItemReorder,
  onSelectCourse,
  onRemoveCourse,
  onCampusChange,
  onBackgroundChange,
  onJumpTodayTimetable,
}

/// 应用程序全局数据对象
class Global {
  static final eventBus = EventBus();

  static late CookieJar cookieJar;
  static late Dio dio;
  static late Dio dio2; // 消费查询专用连接池(因为需要修改连接超时)
  static late SsoSession ssoSession;
  static late SsoSession ssoSession2;

  // 是否正处于网络错误对话框
  static bool inSsoErrorDialog = false;

  static onSsoError(error, stacktrace) {
    final context = $Key.currentContext!;
    if (error is DioError) {
      if (inSsoErrorDialog) return;
      inSsoErrorDialog = true;
      context
          .showRequest(
              title: i18n.network.connectionTimeoutError,
              desc: i18n.network.connectionTimeoutErrorDesc,
              yes: i18n.network.openToolBtn,
              no: i18n.cancel)
          .then((confirm) {
        //if (confirm == true) Navigator.of(context).pushNamed(Routes.networkTool);
        inSsoErrorDialog = false;
      });
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
    required AuthSettingDao authSetting,
    required CredentialDao credentials,
    bool? debugNetwork,
    required Box cookieBox,
  }) async {
    cookieJar = await CookieInit.init(box: cookieBox);
    dio = await DioInit.init(
      config: DioConfig()
        ..cookieJar = cookieJar
        ..httpProxy = GlobalConfig.httpProxy
        ..sendTimeout = 6 * 1000
        ..receiveTimeout = 6 * 1000
        ..connectTimeout = 6 * 1000,
      debug: debugNetwork,
    );
    dio2 = await DioInit.init(
      config: DioConfig()
        ..cookieJar = cookieJar
        ..httpProxy = GlobalConfig.httpProxy
        ..connectTimeout = 30 * 1000
        ..sendTimeout = 30 * 1000
        ..receiveTimeout = 30 * 1000,
      debug: debugNetwork,
    );
    ssoSession =
        SsoSession(dio: dio, cookieJar: cookieJar, onError: onSsoError, onNeedInputCaptcha: onNeedInputCaptcha);
    ssoSession2 =
        SsoSession(dio: dio2, cookieJar: cookieJar, onError: onSsoError, onNeedInputCaptcha: onNeedInputCaptcha);

    // 若本地存放了用户名与密码，那就惰性登录
    final oaCredential = credentials.oaCredential;
    if (oaCredential != null) {
      // 惰性登录
      ssoSession.lazyLogin(oaCredential);
    }
  }
}
