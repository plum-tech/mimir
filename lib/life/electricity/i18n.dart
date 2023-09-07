import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "electricity";
  final unit = const UnitI18n();

  String get title => "$ns.title".tr();

  String get balance => "$ns.balance".tr();

  String get remainingPower => "$ns.remainingPower".tr();

  String get searchInvalidTip => "$ns.searchInvalidTip".tr();

  String get updateSuccessTip => "$ns.updateSuccessTip".tr();

  String get updateFailedTip => "$ns.updateFailedTip".tr();
}
