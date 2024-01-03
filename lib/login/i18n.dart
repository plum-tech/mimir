import 'package:easy_localization/easy_localization.dart';
import 'package:sit/credentials/i18n.dart';
import 'package:sit/l10n/common.dart';

class CommonLoginI18n with CommonI18nMixin {
  const CommonLoginI18n();

  static const ns = "login";
  final network = const NetworkI18n();
  final credentials = const CredentialsI18n();

  String get login => "$ns.login".tr();

  String get forgotPwd => "$ns.forgotPwd".tr();

  String get credentialsValidatedTip => "$ns.credentialsValidatedTip".tr();

  String get formatError => "$ns.formatError".tr();

  String get validateInputAccountPwdRequest => "$ns.validateInputAccountPwdRequest".tr();

  String get loggedInTip => "$ns.loggedInTip".tr();

  String get notLoggedIn => "$ns.notLoggedIn".tr();

  String get invalidAccountFormat => "$ns.invalidAccountFormat".tr();

  String get offlineModeBtn => "$ns.offlineModeBtn".tr();

  String get failedWarn => "$ns.failedWarn".tr();

  String get accountOrPwdErrorTip => "$ns.accountOrPwdErrorTip".tr();

  String get unknownAuthErrorTip => "$ns.unknownAuthErrorTip".tr();

  String get captchaErrorTip => "$ns.captchaErrorTip".tr();

  String get accountFrozenTip => "$ns.accountFrozenTip".tr();

  String get accountLockedTip => "$ns.accountLockedTip".tr();

  String get incompleteUserInfoTip => "$ns.incompleteUserInfoTip".tr();
}

class OaLoginI18n extends CommonLoginI18n {
  const OaLoginI18n();

  static const ns = "${CommonLoginI18n.ns}.oa";

  @override
  OaCredentialsI18n get credentials => const OaCredentialsI18n();

  String get welcomeHeader => "$ns.welcomeHeader".tr();

  String get loginOa => "$ns.loginOa".tr();

  String get accountHint => "$ns.accountHint".tr();

  String get oaPwdHint => "$ns.oaPwdHint".tr();

  String get schoolServerUnconnectedTip => "$ns.schoolServerUnconnectedTip".tr();

  String get loginRequired => "$ns.loginRequired".tr();

  String get neverLoggedInTip => "$ns.neverLoggedInTip".tr();
}
