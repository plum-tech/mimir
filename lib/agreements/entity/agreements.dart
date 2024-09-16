import 'package:easy_localization/easy_localization.dart';

enum AgreementsType {
  basic,
  account;

  String l10n() => "agreements.basic".tr();
}
