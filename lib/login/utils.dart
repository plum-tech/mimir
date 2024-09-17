import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mimir/credentials/error.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/session/sso.dart';
import 'package:mimir/utils/error.dart';
import 'package:mimir/widget/markdown.dart';
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
    await context.showAnyTip(
      serious: true,
      title: _i18n.failedWarn,
      desc: (ctx) => FeaturedMarkdownWidget(data: error.type.l10n()),
      primary: _i18n.close,
    );
    return;
  }
  if (error is DioException) {
    await context.showTip(
      serious: true,
      title: _i18n.failedWarn,
      desc: _i18n.schoolServerUnconnectedTip,
      primary: _i18n.close,
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
    primary: _i18n.close,
  );
  return;
}
