import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sit/credentials/error.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/session/sso.dart';
import 'package:sit/utils/error.dart';
import "./i18n.dart";

const _i18n = OaLoginI18n();

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
      title: _i18n.failedWarn,
      desc: error.type.l10n(),
      ok: _i18n.close,
    );
    return;
  }
  if (error is DioException) {
    await context.showTip(
      serious: true,
      title: _i18n.failedWarn,
      desc: _i18n.schoolServerUnconnectedTip,
      ok: _i18n.close,
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
    title: _i18n.failedWarn,
    desc: _i18n.unknownAuthErrorTip,
    ok: _i18n.close,
  );
  return;
}
