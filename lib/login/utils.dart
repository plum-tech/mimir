import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/exception/session.dart';
import "./i18n.dart";

Future<void> handleLoginException({
  required BuildContext context,
  required Exception error,
  required StackTrace stackTrace,
}) async {
  debugPrint(error.toString());
  debugPrintStack(stackTrace: stackTrace);
  if (error is UnknownAuthException) {
    if (!context.mounted) return;
    await context.showTip(
      serious: true,
      title: i18n.failedWarn,
      desc: i18n.unknownAuthErrorTip,
      ok: i18n.close,
    );
  } else if (error is OaCredentialsException) {
    if (!context.mounted) return;
    if (error.type == OaCredentialsErrorType.accountPassword) {
      await context.showTip(
        serious: true,
        title: i18n.failedWarn,
        desc: i18n.accountOrPwdErrorTip,
        ok: i18n.close,
      );
    } else if (error.type == OaCredentialsErrorType.captcha) {
      await context.showTip(
        serious: true,
        title: i18n.failedWarn,
        desc: i18n.captchaErrorTip,
        ok: i18n.close,
      );
    } else if (error.type == OaCredentialsErrorType.frozen) {
      await context.showTip(
        serious: true,
        title: i18n.failedWarn,
        desc: i18n.accountFrozenTip,
        ok: i18n.close,
      );
    }
    return;
  }
  if (error is DioException) {
    debugPrint(error.toString());
    debugPrintStack(stackTrace: stackTrace);
    if (!context.mounted) return;
    await context.showTip(
      serious: true,
      title: i18n.failedWarn,
      desc: i18n.schoolServerUnconnectedTip,
      ok: i18n.close,
    );
  }
  if (error is LoginCaptchaCancelledException) {
    if (!context.mounted) return;
  }
}
