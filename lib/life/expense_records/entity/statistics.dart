import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sit/utils/date.dart';

import 'local.dart';

typedef StartTime2Records = List<({DateTime start, List<Transaction> records})>;

enum StatisticsMode {
  week(_week),
  month(_month),
  year(_year);

  /// Resort the records, separate them by start time, and sort them in DateTime ascending order.
  final StartTime2Records Function(List<Transaction> records) resort;

  const StatisticsMode(this.resort);

  String l10nName() => "expenseRecords.statsMode.$name".tr();
}

StartTime2Records _week(List<Transaction> records) {
  final ym2records = records.groupListsBy((r) => (r.timestamp.year, r.timestamp.week));
  final startTime2Records = ym2records.entries
      .map((entry) => (start: getDateOfFirstDayInWeek(year: entry.key.$1, week: entry.key.$2), records: entry.value))
      .toList();
  startTime2Records.sortBy((r) => r.start);
  return startTime2Records;
}

StartTime2Records _month(List<Transaction> records) {
  final ym2records = records.groupListsBy((r) => (r.timestamp.year, r.timestamp.month));
  final startTime2Records =
      ym2records.entries.map((entry) => (start: DateTime(entry.key.$1, entry.key.$2), records: entry.value)).toList();
  startTime2Records.sortBy((r) => r.start);
  return startTime2Records;
}

StartTime2Records _year(List<Transaction> records) {
  final ym2records = records.groupListsBy((r) => r.timestamp.year);
  final startTime2Records =
      ym2records.entries.map((entry) => (start: DateTime(entry.key), records: entry.value)).toList();
  startTime2Records.sortBy((r) => r.start);
  return startTime2Records;
}
