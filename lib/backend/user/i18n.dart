import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';
import 'package:mimir/login/i18n.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  final login = const CommonLoginI18n();

  //
  // static const ns = "mimir.user.auth";
  //
  // String get title => "$ns.title".tr();

  String get schoolIdDisclaimer => "mimir.auth.schoolId.disclaimer".tr();
}
