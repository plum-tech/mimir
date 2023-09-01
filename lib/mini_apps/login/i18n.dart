import 'using.dart';

const i18n = LoginI18n();

class LoginI18n with CommonI18nMixin {
  const LoginI18n();

  final network = const NetworkI18n();
  final credential = const CredentialI18n();
  static const ns = "login";

  String get title => "$ns.title".tr();

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

  String get accountOrPwdIncorrectTip => "$ns.accountOrPwdIncorrectTip".tr();

  String get loginBtn => "$ns.loginBtn".tr();
}
