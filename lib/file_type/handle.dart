import 'package:flutter/widgets.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/file_type/protocol.dart';
import 'package:sit/l10n/common.dart';

const _i18n = CommonI18n();

Future<void> onHandleFilePath({
  required BuildContext context,
  required String path,
}) async {
  for (final handler in FileTypeHandlerProtocol.all) {
    if (handler.matchPath(path)) {
      await handler.onHandle(context: context, path: path);
      return;
    }
  }
  if(!context.mounted) return;
  await context.showTip(title: "Unknown file format", desc: "$path", ok: _i18n.ok);
}
