import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';
import 'package:mimir/login/i18n.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "mimir";

  final auth = const _Auth();
  final forum = const _Forum();
  final up = const _Update();

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

class _Forum {
  const _Forum();

  static const ns = "${_I18n.ns}.forum";

  String get navigation => "$ns.navigation".tr();

  String get title => "$ns.title".tr();
}

class _Settings {
  const _Settings();

  static const ns = "${_I18n.ns}.settings";
}

class _Update {
  const _Update();

  static const ns = "${_I18n.ns}.update";

  String get title => "$ns.title".tr();

  String get newVersionAvailable => "$ns.newVersionAvailable".tr();

  String get onLatestTip => "$ns.onLatestTip".tr();

  String get installOnAppStoreInsteadTip => "$ns.installOnAppStoreInsteadTip".tr();

  String get notNow => "$ns.notNow".tr();

  String get skipThisVersionFor7Days => "$ns.skipThisVersionFor7Days".tr();

  String get openAppStore => "$ns.openAppStore".tr();
}
