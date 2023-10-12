import 'dart:async';
import 'dart:typed_data';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sit/credentials/storage/credential.dart';
import 'package:sit/global/cookie_init.dart';
import 'package:sit/global/dio_init.dart';
import 'package:sit/route.dart';
import 'package:sit/session/sso.dart';

import '../widgets/captcha_box.dart';

/// 应用程序全局数据对象
class Global {
  static final eventBus = EventBus();

  static late CookieJar cookieJar;
  static late Dio dio;
  static late SsoSession ssoSession;

  static Future<void> init({
    required CredentialStorage credentials,
    required Box cookieBox,
  }) async {
    cookieJar = CookieInit.init(box: cookieBox);
    dio = await DioInit.init(
      config: DioConfig()
        ..cookieJar = cookieJar
        ..sendTimeout = const Duration(seconds: 6)
        ..receiveTimeout = const Duration(seconds: 6)
        ..connectTimeout = const Duration(seconds: 6),
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
        return await showAdaptiveDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => CaptchaDialog(captchaData: imageBytes),
        );
      },
    );
  }
}
