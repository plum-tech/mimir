import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

class CredentialI18n with CommonI18nMixin {
  static const instance = CredentialI18n();

  const CredentialI18n();

  final network = const NetworkI18n();
  static const _ns = "credential";
  final unauthorizedTip = const _UnauthorizedTip();

  String get studentId => "$_ns.studentId".tr();

  String get account => "$_ns.account".tr();

  String get oaAccount => "$_ns.oaAccount".tr();

  String get oaPwd => "$_ns.oaPwd".tr();

  String get reloginRequestDesc => "$_ns.reloginRequestDesc".tr();

  String get relogin => "$_ns.relogin".tr();

  String get loginLoginBtn => "$_ns.loginLoginBtn".tr();

  String get loginPwdHint => "$_ns.loginPwdHint".tr();

  String get loginFailedWarn => "$_ns.loginFailedWarn".tr();

  String get accountOrPwdIncorrectTip => "$_ns.accountOrPwdIncorrectTip".tr();

  String get loginLoginAccountHint => "$_ns.loginLoginAccountHint".tr();

  String get formatError => "$_ns.formatError".tr();

  String get validateInputAccountPwdRequest => "$_ns.validateInputAccountPwdRequest".tr();

  String get changePwd => "$_ns.changePwd".tr();

  String get changePwdDesc => "$_ns.changePwdDesc".tr();
}

class _UnauthorizedTip {
  const _UnauthorizedTip();

  static const ns = "${CredentialI18n._ns}.unauthorizedTip";

  String get title => "$ns.title".tr();

  String get everLoggedInTip => "$ns.everLoggedInTip".tr();

  String get neverLoggedInTip => "$ns.everLoggedInTip".tr();
}
