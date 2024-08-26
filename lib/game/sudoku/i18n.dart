import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/game/i18n.dart';
import 'package:mimir/l10n/common.dart';

import 'entity/mode.dart';
import 'r.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin, CommonGameI18nMixin {
  const _I18n();

  static const ns = "game.${RSudoku.name}";
  final records = const _Records();

  String get title => "$ns.title".tr();
}

class _Records {
  static const ns = "${_I18n.ns}.records";

  const _Records();

  String get title => "$ns.title".tr();

  String record({
    required GameModeSudoku mode,
    required int blanks,
  }) =>
      "$ns.record".tr(namedArgs: {
        "mode": mode.l10n(),
        "blanks": "$blanks",
      });
}
