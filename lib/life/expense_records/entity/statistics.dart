import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';

import 'local.dart';

typedef StartTime2Records = List<({DateTime start, List<Transaction> records})>;

enum StatisticsMode {
  week(_weekly),
  month(_monthly),
  year(_yearly);

  final StartTime2Records Function(List<Transaction> records) resort;

  const StatisticsMode(this.resort);

  String l10nName() => "expenseRecords.statsMode.$name".tr();
}

StartTime2Records _weekly(List<Transaction> records) {
  return [];
}

StartTime2Records _monthly(List<Transaction> records) {
  final ym2records = records.groupListsBy((r) => (r.timestamp.year, r.timestamp.month));
  final startTime2Records =
      ym2records.entries.map((entry) => (start: DateTime(entry.key.$1, entry.key.$2), records: entry.value)).toList();
  return startTime2Records;
}

StartTime2Records _yearly(List<Transaction> records) {
  final ym2records = records.groupListsBy((r) => r.timestamp.year);
  final startTime2Records =
      ym2records.entries.map((entry) => (start: DateTime(entry.key), records: entry.value)).toList();
  return startTime2Records;
}
