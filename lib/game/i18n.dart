import 'package:easy_localization/easy_localization.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "game";

  String get navigation => "$ns.navigation".tr();

  String get newGame => "$ns.newGame".tr();

  String get loadGame => "$ns.loadGame".tr();
}
