import 'package:catcher/catcher.dart';
import 'package:catcher/model/platform_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/launcher.dart';
import 'package:mimir/storage/init.dart';
import 'package:stack_trace/stack_trace.dart';

import 'logger.dart';

class MimirDialogHandler extends ReportHandler {
  @override
  String toString() {
    return 'DialogHandler';
  }

  @override
  List<PlatformType> getSupportedPlatforms() => [
        PlatformType.android,
        PlatformType.iOS,
        PlatformType.web,
        PlatformType.linux,
        PlatformType.macOS,
        PlatformType.windows,
      ];

  @override
  Future<bool> handle(Report error, BuildContext? context) async {
    if (context == null) return true;
    if (Kv.developOptions.showErrorInfoDialog == null) return true;
    if (!Kv.developOptions.showErrorInfoDialog!) return true;

    Trace trace = Trace.from(error.stackTrace);
    var frameList = trace.frames.where((e) => e.uri.path.startsWith('mimir')).toList();
    var errorMsg = error.error.toString();
    if (frameList.isEmpty && errorMsg.contains('Source stack:')) {
      final msgAndSt = errorMsg.split('Source stack:');
      Log.info(msgAndSt);
      errorMsg = msgAndSt[0];
      frameList = Trace.parse(msgAndSt[1]).frames.where((e) => e.uri.path.startsWith('mimir')).toList();
    }
    await context.showAnyTip(
      title: i18n.exceptionInfo,
      ok: i18n.close,
      make: (ctx) => SizedBox(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SelectableText(errorMsg),
              ...frameList.asMap().entries.map((entry) {
                final index = entry.key;
                final e = entry.value;
                // const githubUrl = 'https://hub.fastgit.xyz';
                const githubUrl = 'https://github.com';
                final url =
                    '$githubUrl/Liplum/mimir/blob/master/lib${e.uri.path.substring(4)}${e.line != null ? '#L${e.line}' : ''}';
                return Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        splashFactory: NoSplash.splashFactory,
                        enableFeedback: false,
                        shape: const RoundedRectangleBorder()),
                    onPressed: () => GlobalLauncher.launch(url),
                    child: Text("[#$index] $e"),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
    return true;
  }
}

class MimirToastHandler extends ReportHandler {
  @override
  String toString() {
    return 'MyToastHandler';
  }

  @override
  List<PlatformType> getSupportedPlatforms() => [
        PlatformType.android,
        PlatformType.iOS,
        PlatformType.web,
        PlatformType.linux,
        PlatformType.macOS,
        PlatformType.windows,
      ];

  @override
  Future<bool> handle(Report error, BuildContext? context) async {
    if (context == null) return true;
    EasyLoading.showToast(
      '程序好像有点小问题',
      toastPosition: EasyLoadingToastPosition.bottom,
    );
    return true;
  }
}
