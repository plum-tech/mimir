import 'package:easy_localization/easy_localization.dart';

enum AgreementType {
  basic,
  account;

  String l10n() => "agreements.basic".tr();
}
