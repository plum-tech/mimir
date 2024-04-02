enum TimetablePatchType {
  removeLesson,
  removeDay,
  moveLesson,
  moveDay,
  addLesson,
}

abstract class TimetablePatch {
  TimetablePatchType get type;
}

class RemoveLessonTimetablePatch implements TimetablePatch {
  @override
  final type = TimetablePatchType.removeLesson;

  const RemoveLessonTimetablePatch();
}

class RemoveDayTimetablePatch implements TimetablePatch {
  @override
  final type = TimetablePatchType.removeDay;

  const RemoveDayTimetablePatch();
}

class MoveLessonTimetablePatch implements TimetablePatch {
  @override
  final type = TimetablePatchType.moveLesson;

  const MoveLessonTimetablePatch();
}

class MoveDayTimetablePatch implements TimetablePatch {
  @override
  final type = TimetablePatchType.moveDay;

  const MoveDayTimetablePatch();
}

class AddLessonTimetablePatch implements TimetablePatch {
  @override
  final type = TimetablePatchType.addLesson;

  const AddLessonTimetablePatch();
}
