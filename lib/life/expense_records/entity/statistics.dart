import 'package:easy_localization/easy_localization.dart';

enum StatisticsMode {
  week,
  month,
  year;

  String l10nName() => "expenseRecords.statsMode.$name".tr();
}
