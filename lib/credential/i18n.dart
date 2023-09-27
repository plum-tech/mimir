import 'package:easy_localization/easy_localization.dart';
import 'package:mimir/l10n/common.dart';

class CredentialI18n with CommonI18nMixin {
  const CredentialI18n();

  final network = const NetworkI18n();
  static const ns = "credential";

  String get studentId => "$ns.studentId".tr();

  String get account => "$ns.account".tr();

  String get oaAccount => "$ns.oaAccount".tr();

  String get oaPwd => "$ns.oaPwd".tr();

  String get savedOaPwd => "$ns.savedOaPwd".tr();

  String get savedOaPwdDesc => "$ns.savedOaPwdDesc".tr();
}
