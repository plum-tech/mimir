import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/l10n/common.dart';

Future<bool> ensurePermission(Permission permission) async {
  PermissionStatus status = await permission.status;

  if (status != PermissionStatus.granted) {
    status = await Permission.storage.request();
  }
  return status == PermissionStatus.granted;
}

class PermissionI18n with CommonI18nMixin {
  const PermissionI18n();

  static const _ns = "permission";

  String get permissionDenied => "$_ns.permissionDenied".tr();

  String permissionDeniedDescOf(Permission permission) => "$_ns.permissionDeniedDescOf".tr(args: [
        permission.l10n(),
      ]);

  String get goSettings => "$_ns.goSettings".tr();
}

const _i18n = PermissionI18n();

Future<void> showPermissionDeniedDialog({
  required BuildContext context,
  required Permission permission,
}) async {
  final confirm = await context.showDialogRequest(
    title: _i18n.permissionDenied,
    desc: _i18n.permissionDeniedDescOf(permission),
    primary: _i18n.goSettings,
    secondary: _i18n.cancel,
  );
  if (confirm == true) {
    await AppSettings.openAppSettings(type: AppSettingsType.settings);
  }
}

extension PermissionI18nX on Permission {
  String l10n() => "${PermissionI18n._ns}.type.${toString().substring(11)}".tr();
}
