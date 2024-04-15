import 'package:easy_localization/easy_localization.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();
const _ns = "game";

class _I18n with CommonI18nMixin {
  const _I18n();

  String get navigation => "$_ns.navigation".tr();

  String get newGame => "$_ns.newGame".tr();

  String get continueGame => "$_ns.continueGame".tr();
}

mixin class CommonGameI18nMixin {
  String get newGame => "$_ns.newGame".tr();

  String get tryAgain => "$_ns.tryAgain".tr();

  String get youWin => "$_ns.youWin".tr();

  String get gameOver => "$_ns.gameOver".tr();
}

mixin class CommonGameSettingsI18nMixin {
  static const ns = "$_ns.settings";

  String get enableHapticFeedback => "$ns.enableHapticFeedback".tr();

  String get enableHapticFeedbackDesc => "$ns.enableHapticFeedbackDesc".tr();
}
