import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  static const ns = "agreements";

  const _I18n();

  String get privacyPolicy => "$ns.privacyPolicy".tr();

  String get acceptanceRequired => "$ns.acceptanceRequired.title".tr();

  String get acceptanceRequiredDesc => "$ns.acceptanceRequired.desc".tr();
}
