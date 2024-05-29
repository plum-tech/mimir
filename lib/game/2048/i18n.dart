import 'package:easy_localization/easy_localization.dart';
import 'package:sit/game/i18n.dart';
import 'package:sit/l10n/common.dart';

import 'r.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin, CommonGameI18nMixin {
  const _I18n();

  static const ns = "game.${R2048.name}";
  final records = const _Records();

  String get title => "$ns.title".tr();

  String get score => "$ns.score".tr();

  String get best => "$ns.best".tr();

  String get max => "$ns.max".tr();
}

class _Records {
  static const ns = "${_I18n.ns}.records";

  const _Records();

  String get title => "$ns.title".tr();

  String record({
    required int maxNumber,
    required int score,
  }) =>
      "$ns.record".tr(namedArgs: {
        "maxNumber": "$maxNumber",
        "score": "$score",
      });
}
