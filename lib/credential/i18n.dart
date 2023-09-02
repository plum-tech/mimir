import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

class CredentialI18n with CommonI18nMixin {
  static const instance = CredentialI18n();

  const CredentialI18n();

  final network = const NetworkI18n();
  static const ns = "credential";

  String get studentId => "$ns.studentId".tr();

  String get account => "$ns.account".tr();

  String get oaAccount => "$ns.oaAccount".tr();

  String get oaPwd => "$ns.oaPwd".tr();

  String get savedOaPwd => "$ns.savedOaPwd".tr();

  String get reloginRequestDesc => "$ns.reloginRequestDesc".tr();

  String get relogin => "$ns.relogin".tr();

  String get loginLoginBtn => "$ns.loginLoginBtn".tr();

  String get loginPwdHint => "$ns.loginPwdHint".tr();

  String get loginFailedWarn => "$ns.loginFailedWarn".tr();

  String get accountOrPwdIncorrectTip => "$ns.accountOrPwdIncorrectTip".tr();

  String get loginLoginAccountHint => "$ns.loginLoginAccountHint".tr();

  String get formatError => "$ns.formatError".tr();

  String get validateInputAccountPwdRequest => "$ns.validateInputAccountPwdRequest".tr();

  String get changeSavedOaPwd => "$ns.changeSavedOaPwd".tr();

  String get changeSavedOaPwdDesc => "$ns.changeSavedOaPwdDesc".tr();
}
