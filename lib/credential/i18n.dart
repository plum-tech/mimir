import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

class CredentialI18n with CommonI18nMixin {
  const CredentialI18n();

  final network = const NetworkI18n();

  final unauthorizedTip = const _UnauthorizedTip();

  String get studentId => "studentId".tr();

  String get account => "account".tr();

  String get oaPwd => "oaPwd".tr();

  String get reloginRequestDesc => "reloginRequestDesc".tr();

  String get relogin => "relogin".tr();

  String get loginLoginBtn => "loginLoginBtn".tr();

  String get loginPwdHint => "loginPwdHint".tr();

  String get loginFailedWarn => "loginFailedWarn".tr();

  String get accountOrPwdIncorrectTip => "accountOrPwdIncorrectTip".tr();

  String get loginLoginAccountHint => "loginLoginAccountHint".tr();

  String get formatError => "formatError".tr();

  String get validateInputAccountPwdRequest => "validateInputAccountPwdRequest".tr();
}

class _UnauthorizedTip {
  const _UnauthorizedTip();

  String get title => "title".tr();

  String get everLoggedInTip => "everLoggedInTip".tr();

  String get neverLoggedInTip => "everLoggedInTip".tr();
}
