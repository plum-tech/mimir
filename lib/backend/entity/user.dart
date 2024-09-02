import 'package:easy_localization/easy_localization.dart';

enum SchoolCode {
  sit("10259");

  final String code;

  const SchoolCode(this.code);

  String l10n() => "mimir.school.$code".tr();
}
