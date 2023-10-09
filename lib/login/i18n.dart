import 'package:easy_localization/easy_localization.dart';
import 'package:sit/credential/i18n.dart';
import 'package:sit/l10n/common.dart';

const i18n = LoginI18n();

class LoginI18n with CommonI18nMixin {
  const LoginI18n();

  final network = const NetworkI18n();
  final credential = const CredentialI18n();
  static const ns = "login";

  String get welcomeHeader => "$ns.welcomeHeader".tr();

  String get loginOa => "$ns.loginOa".tr();

  String get credentialsValidatedTip => "$ns.credentialsValidatedTip".tr();

  String get accountHint => "$ns.accountHint".tr();

  String get formatError => "$ns.formatError".tr();

  String get validateInputAccountPwdRequest => "$ns.validateInputAccountPwdRequest".tr();

  String get forgotPwdBtn => "$ns.forgotPwdBtn".tr();

  String get loggedInTip => "$ns.loggedInTip".tr();

  String get notLoggedIn => "$ns.notLoggedIn".tr();

  String get invalidAccountFormat => "$ns.invalidAccountFormat".tr();

  String get offlineModeBtn => "$ns.offlineModeBtn".tr();

  String get oaPwdHint => "$ns.oaPwdHint".tr();

  String get failedWarn => "$ns.failedWarn".tr();

  String get accountOrPwdErrorTip => "$ns.accountOrPwdErrorTip".tr();

  String get unknownAuthErrorTip => "$ns.unknownAuthErrorTip".tr();

  String get captchaErrorTip => "$ns.captchaErrorTip".tr();

  String get accountFrozenTip => "$ns.accountFrozenTip".tr();

  String get schoolServerUnconnectedTip => "$ns.schoolServerUnconnectedTip".tr();

  String get loginBtn => "$ns.loginBtn".tr();

  String get loginRequired => "$ns.loginRequired".tr();

  String get neverLoggedInTip => "$ns.neverLoggedInTip".tr();
}
