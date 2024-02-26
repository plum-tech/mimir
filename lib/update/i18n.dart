import 'package:easy_localization/easy_localization.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "update";

  String get title => "$ns.title".tr();

  String get newVersionAvailable => "$ns.newVersionAvailable".tr();

  String get notNow => "$ns.notNow".tr();

  String get skipThisVersion => "$ns.skipThisVersion".tr();
}
