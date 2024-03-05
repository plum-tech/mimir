import 'package:easy_localization/easy_localization.dart';
import 'package:sit/game/minesweeper/model/mode.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "game.minesweeper";

  String get title => "$ns.title".tr();

  String get gameOverFailed => "$ns.gameOver.failed".tr();

  String get gameOverWon => "$ns.gameOver.won".tr();

  String get restart => "$ns.restart".tr();
}

extension GameModeI18nX on GameMode {
  String l10n() => "${_I18n.ns}.gameMode.$name".tr();
}
