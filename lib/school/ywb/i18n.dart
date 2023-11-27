import 'package:easy_localization/easy_localization.dart';
import 'package:sit/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "ywb";

  final mine = const _Mine();
  final details = const _Details();

  String get title => "$ns.title".tr();

  String get info => "$ns.info".tr();

  String get mineAction => mine.title;

  String get noServicesTip => "$ns.noServicesTip".tr();
}

class _Mine {
  const _Mine();

  static const ns = "${_I18n.ns}.mine";

  String get title => "$ns.title".tr();

  String get noApplicationsTip => "$ns.noApplicationsTip".tr();
}

class _Details {
  const _Details();

  static const ns = "${_I18n.ns}.details";

  String get apply => "$ns.apply".tr();
}
