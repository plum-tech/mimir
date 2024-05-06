import 'package:easy_localization/easy_localization.dart';
import 'package:sit/game/i18n.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin, CommonGameI18nMixin {
  const _I18n();

  static const ns = "game.2048";

  String get title => "$ns.title".tr();

  String get score => "$ns.score".tr();

  String get best => "$ns.best".tr();
}

class _Settings {
  const _Settings();

  static const ns = "${_I18n.ns}.settings";
}
