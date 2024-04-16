import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sit/credentials/error.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/lifecycle.dart';
import 'package:sit/login/i18n.dart';

void debugPrintError(Object? error, [StackTrace? stackTrace]) {
  if (error == null) {
    return;
  } else if (error is DioException) {
    debugPrint(error.toString());
    debugPrintStack(stackTrace: error.stackTrace, maxFrames: 10);
  } else if (error is AsyncError) {
    debugPrintError(error.error, error.stackTrace);
  } else if (error is ParallelWaitError) {
    final errors = error.errors;
    if (errors is (AsyncError?, AsyncError?)) {
      debugPrintError(errors.$1);
      debugPrintError(errors.$2);
    } else {
      debugPrint(errors.toString());
    }
  } else {
    debugPrint(error.toString());
    debugPrintStack(stackTrace: stackTrace);
  }
}

const _i18n = CommonLoginI18n();

Future<void> handleRequestError(Object? error, [StackTrace? stackTrace]) async {
  debugPrintError(error, stackTrace);
  final context = $key.currentContext;
  if (error is CredentialsException) {
    if (context == null || context.mounted) return;
    await context.showTip(
      serious: true,
      title: _i18n.failedWarn,
      desc: error.type.l10n(),
      ok: _i18n.close,
    );
    return;
  }
}
