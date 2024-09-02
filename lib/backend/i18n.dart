import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';
import 'package:mimir/login/i18n.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "mimir";

  final auth = const _Auth();

  String get school => "$ns.school.title".tr();
}

class _Auth with CommonAuthI18nMixin {
  const _Auth();

  static const ns = "${_I18n.ns}.auth";

  String get signInTitle => "$ns.signInTitle".tr();

  String get acceptAgreements => "$ns.acceptAgreements".tr();

  String get authMethodsAvailable => "$ns.authMethodsAvailable".tr();

  String get authMethodUnimpl => "$ns.authMethodUnimpl".tr();

  String get schoolIdDisclaimer => "$ns.schoolId.disclaimer".tr();
}

class _Settings {
  const _Settings();

  static const ns = "${_I18n.ns}.settings";
}
