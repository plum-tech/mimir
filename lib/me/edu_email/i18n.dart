import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

const i18n = _I18n();

class _I18n with CommonI18nMixin {
  const _I18n();

  static const ns = "eduEmail";
  final action = const _Action();

  String get title => "$ns.title".tr();

  String get noContent => "$ns.noContent".tr();

  String get noSubject => "$ns.noSubject".tr();

  String get pluralSenderTailing => "$ns.pluralSenderTailing".tr();

  String get text => "$ns.text".tr();

  String get loginBtn => "$ns.loginBtn".tr();

  String get addressHint => "$ns.addressHint".tr();

  String get failedWarn => "$ns.failedWarn".tr();

  String get forgotPwdBtn => "$ns.forgotPwdBtn".tr();
}

class _Action {
  const _Action();

  static const ns = "${_I18n.ns}.action";

  String get login => "$ns.login".tr();

  String get inbox => "$ns.inbox".tr();

  String get sentItems => "$ns.sentItems".tr();
}
