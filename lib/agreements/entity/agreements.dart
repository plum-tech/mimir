import 'package:easy_localization/easy_localization.dart';

enum AgreementType {
  basic,
  account;

  String l10n() => "agreements.basic".tr();
}

enum AgreementVersion {
  v20240915("20240915"),
  ;

  static const current = v20240915;

  final String number;

  const AgreementVersion(this.number);
}
