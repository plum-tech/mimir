import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/game/i18n.dart';
import 'package:mimir/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin, CommonGameI18nMixin {
  const _I18n();

  static const ns = "game.wordle";

  String get title => "$ns.title".tr();

  String timeSpent(String time) => "$ns.timeSpent".tr(args: [time]);
}
