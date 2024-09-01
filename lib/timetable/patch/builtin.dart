import '../entity/loc.dart';
import 'entity/patch.dart';

class BuiltinTimetablePatchSets {
  static final vacationShift2024 = BuiltinTimetablePatchSet(
    key: "sitVacationShift2024",
    recommended: (timetable) {
      return timetable.schoolYear == 2024 || timetable.schoolYear == 2023;
    },
    patches: [
      // New Year's Day
      TimetableRemoveDayPatch.oneDay(loc: TimetableDayLoc.byDate(2024, 1, 1)),
      // Qingming Festival
      TimetableRemoveDayPatch.oneDay(loc: TimetableDayLoc.byDate(2024, 4, 4)),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.byDate(2024, 4, 3),
        target: TimetableDayLoc.byDate(2024, 4, 7),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.byDate(2024, 4, 5),
        target: TimetableDayLoc.byDate(2024, 4, 3),
      ),
      // International Workers' Day
      TimetableMoveDayPatch(
        source: TimetableDayLoc.byDate(2024, 4, 30),
        target: TimetableDayLoc.byDate(2024, 4, 28),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.byDate(2024, 5, 3),
        target: TimetableDayLoc.byDate(2024, 4, 30),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.byDate(2024, 5, 10),
        target: TimetableDayLoc.byDate(2024, 5, 11),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.byDate(2024, 5, 2),
        target: TimetableDayLoc.byDate(2024, 5, 10),
      ),
      TimetableRemoveDayPatch.oneDay(loc: TimetableDayLoc.byDate(2024, 5, 1)),
      // Dragon Boat Festival
      TimetableRemoveDayPatch.oneDay(loc: TimetableDayLoc.byDate(2024, 6, 10)),
      // Mid-Autumn Festival
      TimetableMoveDayPatch(
        source: TimetableDayLoc.byDate(2024, 9, 13),
        target: TimetableDayLoc.byDate(2024, 9, 14),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.byDate(2024, 9, 16),
        target: TimetableDayLoc.byDate(2024, 9, 13),
      ),
      TimetableRemoveDayPatch.oneDay(loc: TimetableDayLoc.byDate(2024, 9, 17)),
      // the National Day of the PRC
      TimetableMoveDayPatch(
        source: TimetableDayLoc.byDate(2024, 9, 30),
        target: TimetableDayLoc.byDate(2024, 9, 29),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.byDate(2024, 10, 4),
        target: TimetableDayLoc.byDate(2024, 9, 30),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.byDate(2024, 10, 11),
        target: TimetableDayLoc.byDate(2024, 10, 12),
      ),
      TimetableMoveDayPatch(
        source: TimetableDayLoc.byDate(2024, 10, 7),
        target: TimetableDayLoc.byDate(2024, 10, 11),
      ),
      TimetableRemoveDayPatch(all: [
        TimetableDayLoc.byDate(2024, 10, 1),
        TimetableDayLoc.byDate(2024, 10, 2),
        TimetableDayLoc.byDate(2024, 10, 3),
        TimetableDayLoc.byDate(2024, 10, 5),
        TimetableDayLoc.byDate(2024, 10, 6),
      ]),
    ],
  );
  static final all = [
    vacationShift2024,
  ];
}
