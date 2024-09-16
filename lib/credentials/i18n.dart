import 'package:easy_localization/easy_localization.dart';

class CredentialsI18n with CredentialsI18nMixin {
  const CredentialsI18n();
}

mixin class CredentialsI18nMixin {
  static const ns = "credentials";

  String get account => "$ns.account".tr();

  String get pwd => "$ns.pwd".tr();

  String get savedPwd => "$ns.savedPwd".tr();

  String get savedPwdDesc => "$ns.savedPwdDesc".tr();
}

class OaCredentialsI18n extends CredentialsI18n {
  const OaCredentialsI18n();

  static const ns = "${CredentialsI18nMixin.ns}.oa";

  String get studentId => "$ns.studentId".tr();

  String get oaAccount => "$ns.oaAccount".tr();

  String get oaPwd => "$ns.oaPwd".tr();
}

class EmailCredentialsI18n extends CredentialsI18n {
  const EmailCredentialsI18n();

  static const ns = "${CredentialsI18nMixin.ns}.email";

  String get eduEmail => "$ns.eduEmail".tr();

  String get emailAddress => "$ns.emailAddress".tr();
}
