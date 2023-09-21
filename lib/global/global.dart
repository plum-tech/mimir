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
import 'package:mimir/session/sso.dart';
import 'package:mimir/settings/settings.dart';

import '../widgets/captcha_box.dart';

/// 应用程序全局数据对象
class Global {
  static final eventBus = EventBus();

  static late CookieJar cookieJar;
  static late Dio dio;
  static late SsoSession ssoSession;

  static Future<void> init({
    required CredentialStorage credentials,
    bool? debugNetwork,
    required Box cookieBox,
  }) async {
    cookieJar = CookieInit.init(box: cookieBox);
    dio = await DioInit.init(
      config: DioConfig()
        ..cookieJar = cookieJar
        ..httpProxy = Settings.httpProxy
        ..sendTimeout = const Duration(seconds: 6)
        ..receiveTimeout = const Duration(seconds: 6)
        ..connectTimeout = const Duration(seconds: 6),
      debug: debugNetwork,
    );
    ssoSession = SsoSession(
      dio: dio,
      cookieJar: cookieJar,
      onError: (error, stackTrace) {
        debugPrint(error.toString());
        debugPrintStack(stackTrace: stackTrace);
      },
      inputCaptcha: (Uint8List imageBytes) async {
        final context = $Key.currentContext!;
        return await context.show$Dialog$(
          dismissible: false,
          make: (context) => CaptchaBox(captchaData: imageBytes),
        );
      },
    );
  }
}
