import 'package:easy_localization/easy_localization.dart';
import 'package:sit/l10n/common.dart';

class CredentialsI18n with CommonI18nMixin {
  const CredentialsI18n();

  final network = const NetworkI18n();
  static const ns = "credentials";

  String get studentId => "$ns.studentId".tr();

  String get account => "$ns.account".tr();

  String get oaAccount => "$ns.oaAccount".tr();

  String get oaPwd => "$ns.oaPwd".tr();

  String get savedOaPwd => "$ns.savedOaPwd".tr();

  String get savedOaPwdDesc => "$ns.savedOaPwdDesc".tr();
}
