enum TimetablePatchType {
  removeLesson,
  removeDay,
  moveLesson,
  moveDay,
  addLesson,
  swipeLesson,
  swipeDay,
  replaceLesson,
  replaceDay,
}

abstract class TimetablePatch {
  TimetablePatchType get type;
}

class TimetableRemoveLessonPatch implements TimetablePatch {
  @override
  final type = TimetablePatchType.removeLesson;

  const TimetableRemoveLessonPatch();
}

class TimetableRemoveDayPatch implements TimetablePatch {
  @override
  final type = TimetablePatchType.removeDay;

  const TimetableRemoveDayPatch();
}

class TimetableMoveLessonPatch implements TimetablePatch {
  @override
  final type = TimetablePatchType.moveLesson;

  const TimetableMoveLessonPatch();
}

class TimetableMoveDayPatch implements TimetablePatch {
  @override
  final type = TimetablePatchType.moveDay;

  const TimetableMoveDayPatch();
}

class TimetableAddLessonPatch implements TimetablePatch {
  @override
  final type = TimetablePatchType.addLesson;

  const TimetableAddLessonPatch();
}
