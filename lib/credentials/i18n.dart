import 'package:easy_localization/easy_localization.dart';

class CredentialsI18n with CredentialsI18nMixin {
  const CredentialsI18n();
}

mixin class CredentialsI18nMixin {
  static const ns = "credentials";

  String get account => "$ns.account".tr();

  String get pwd => "$ns.pwd".tr();
}

class OaCredentialsI18n extends CredentialsI18n {
  const OaCredentialsI18n();

  static const ns = "${CredentialsI18nMixin.ns}.oa";

  String get studentId => "$ns.studentId".tr();

  String get oaAccount => "$ns.oaAccount".tr();

  String get oaPwd => "$ns.oaPwd".tr();

  String get savedOaPwd => "$ns.savedOaPwd".tr();

  String get savedOaPwdDesc => "$ns.savedOaPwdDesc".tr();
}
