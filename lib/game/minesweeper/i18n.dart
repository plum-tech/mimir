import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/game/i18n.dart';
import 'package:mimir/game/minesweeper/entity/mode.dart';
import 'package:mimir/l10n/common.dart';

import 'r.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin, CommonGameI18nMixin {
  const _I18n();

  static const ns = "game.${RMinesweeper.name}";
  final records = const _Records();

  String get title => "$ns.title".tr();

  String timeSpent(String time) => "$ns.timeSpent".tr(args: [time]);
}

class _Records {
  static const ns = "${_I18n.ns}.records";

  const _Records();

  String get title => "$ns.title".tr();

  String record({
    required GameModeMinesweeper mode,
    required int rows,
    required int columns,
    required int mines,
  }) =>
      "$ns.record".tr(namedArgs: {
        "mode": mode.l10n(),
        "rows": "$rows",
        "columns": "$columns",
        "mines": "$mines",
      });
}
