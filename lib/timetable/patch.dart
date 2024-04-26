import 'entity/loc.dart';
import 'entity/patch.dart';

class BuiltinTimetablePatchSets {
  static final vacationShift2024 = BuiltinTimetablePatchSet(
    key: "vacationShift2024",
    patches: [
      TimetableMoveDayPatch(
        source: TimetableDayLoc.date(DateTime(2024, 4, 30)),
        target: TimetableDayLoc.date(DateTime(2024, 4, 28)),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.date(DateTime(2024, 5, 2)),
        target: TimetableDayLoc.date(DateTime(2024, 5, 10)),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.date(DateTime(2024, 5, 10)),
        target: TimetableDayLoc.date(DateTime(2024, 5, 11)),
      ),
    ],
  );
  static final all = [
    vacationShift2024,
  ];
}
