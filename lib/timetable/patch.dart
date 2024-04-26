import 'entity/loc.dart';
import 'entity/patch.dart';

class BuiltinTimetablePatchSets {
  static final vacationShift2024 = BuiltinTimetablePatchSet(
    key: "sitVacationShift2024",
    patches: [
      TimetableRemoveDayPatch(loc: TimetableDayLoc.date(DateTime(2024, 1, 1))),
      TimetableRemoveDayPatch(loc: TimetableDayLoc.date(DateTime(2024, 4, 4))),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.date(DateTime(2024, 4, 5)),
        target: TimetableDayLoc.date(DateTime(2024, 4, 3)),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.date(DateTime(2024, 4, 3)),
        target: TimetableDayLoc.date(DateTime(2024, 4, 7)),
      ),
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
      TimetableRemoveDayPatch(loc: TimetableDayLoc.date(DateTime(2024, 6, 10))),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.date(DateTime(2024, 9, 16)),
        target: TimetableDayLoc.date(DateTime(2024, 9, 13)),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.date(DateTime(2024, 9, 13)),
        target: TimetableDayLoc.date(DateTime(2024, 9, 14)),
      ),
      TimetableRemoveDayPatch(loc: TimetableDayLoc.date(DateTime(2024, 9, 17))),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.date(DateTime(2024, 9, 4)),
        target: TimetableDayLoc.date(DateTime(2024, 9, 29)),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.date(DateTime(2024, 10, 4)),
        target: TimetableDayLoc.date(DateTime(2024, 9, 30)),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.date(DateTime(2024, 10, 7)),
        target: TimetableDayLoc.date(DateTime(2024, 10, 11)),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.date(DateTime(2024, 10, 11)),
        target: TimetableDayLoc.date(DateTime(2024, 10, 12)),
      ),
      TimetableRemoveDayPatch(loc: TimetableDayLoc.date(DateTime(2024, 10, 1))),
      TimetableRemoveDayPatch(loc: TimetableDayLoc.date(DateTime(2024, 10, 2))),
      TimetableRemoveDayPatch(loc: TimetableDayLoc.date(DateTime(2024, 10, 3))),
      TimetableRemoveDayPatch(loc: TimetableDayLoc.date(DateTime(2024, 10, 4))),
      TimetableRemoveDayPatch(loc: TimetableDayLoc.date(DateTime(2024, 10, 5))),
      TimetableRemoveDayPatch(loc: TimetableDayLoc.date(DateTime(2024, 10, 6))),
      TimetableRemoveDayPatch(loc: TimetableDayLoc.date(DateTime(2024, 10, 7)))
    ],
  );
  static final all = [
    vacationShift2024,
  ];
}
