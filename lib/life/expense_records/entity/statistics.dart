import 'package:easy_localization/easy_localization.dart';

enum StatisticsMode {
  weekly,
  monthly,
  yearly;

  String l10nName() => "expenseRecords.statsMode.$name".tr();
}
