import 'package:easy_localization/easy_localization.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();
const _ns = "game";

class _I18n with CommonI18nMixin, CommonGameI18nMixin {
  const _I18n();

  final settings = const _Settings();

  String get navigation => "$_ns.navigation".tr();

  String get continueGame => "$_ns.continueGame".tr();
}

mixin class CommonGameI18nMixin {
  String get gameMode => "$_ns.gameMode".tr();

  String get tryAgain => "$_ns.tryAgain".tr();

  String get newGame => "$_ns.newGame".tr();

  String get youWin => "$_ns.youWin".tr();

  String get gameOver => "$_ns.gameOver".tr();

  String get changeGameModeRequest => "$_ns.changeGameModeRequest".tr();

  String changeGameModeAction(String newMode) => "$_ns.changeGameModeAction".tr(args: [newMode]);
}

class _Settings {
  static const ns = "$_ns.settings";

  const _Settings();

  String get enableHapticFeedback => "$ns.enableHapticFeedback.title".tr();

  String get enableHapticFeedbackDesc => "$ns.enableHapticFeedback.desc".tr();
}

extension DurationI18nX on Duration {
  String formatPlaytime() {
    final min = inMinutes.toString();
    final sec = inSeconds.remainder(60).toString();
    return '$min:${sec.padLeft(2, "0")}';
  }
}
