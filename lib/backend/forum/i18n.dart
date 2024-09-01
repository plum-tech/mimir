import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "mimir.forum";

  String get navigation => "$ns.navigation".tr();
  String get title => "$ns.title".tr();
}
