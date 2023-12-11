import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sit/credentials/error.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/session/sso.dart';
import 'package:sit/utils/error.dart';
import "./i18n.dart";

Future<void> handleLoginException({
  required BuildContext context,
  required Exception error,
  required StackTrace stackTrace,
}) async {
  debugPrintError(error, stackTrace);
  if (!context.mounted) return;
  if (error is CredentialsException) {
    await context.showTip(
      serious: true,
      title: i18n.failedWarn,
      desc: switch (error.type) {
        CredentialsErrorType.accountPassword => i18n.accountOrPwdErrorTip,
        CredentialsErrorType.captcha => i18n.captchaErrorTip,
        CredentialsErrorType.frozen => i18n.accountFrozenTip,
      },
      ok: i18n.close,
    );
    return;
  }
  if (error is DioException) {
    await context.showTip(
      serious: true,
      title: i18n.failedWarn,
      desc: i18n.schoolServerUnconnectedTip,
      ok: i18n.close,
    );
    return;
  }
  if (error is LoginCaptchaCancelledException) {
    if (!context.mounted) return;
    return;
  }
  if (!context.mounted) return;
  await context.showTip(
    serious: true,
    title: i18n.failedWarn,
    desc: i18n.unknownAuthErrorTip,
    ok: i18n.close,
  );
  return;
}
