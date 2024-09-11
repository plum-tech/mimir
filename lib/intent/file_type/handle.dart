import 'package:flutter/widgets.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/l10n/common.dart';
import 'registry.dart';

const _i18n = CommonI18n();

Future<void> onHandleFilePath({
  required BuildContext context,
  required String path,
}) async {
  for (final handler in FileTypeHandlers.all) {
    if (handler.matchPath(path)) {
      await handler.onHandle(context: context, path: path);
      return;
    }
  }
  if (!context.mounted) return;
  await context.showTip(title: "Unknown file format", desc: path, primary: _i18n.ok);
}
