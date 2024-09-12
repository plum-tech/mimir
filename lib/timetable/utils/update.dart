import 'package:flutter/widgets.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/school/entity/school.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/timetable/entity/timetable.dart';
import 'package:mimir/timetable/init.dart';

bool canSyncTimetable(Timetable old) {
  final credentials = CredentialsInit.storage.oa.credentials;
  if (credentials == null) return false;
  if (old.studentId != credentials.account) return false;
  if (old.campus != Settings.campus) return false;
  return true;
}

Future<Timetable> _fetchSameTypeTimetable(Timetable old) async {
  final info = SemesterInfo(year: old.schoolYear, semester: old.semester);
  if (old.studentType == StudentType.undergraduate) {
    return await TimetableInit.service.fetchUgTimetable(info);
  } else {
    return await TimetableInit.service.fetchPgTimetable(info);
  }
}

Future<Timetable?> syncTimetable(BuildContext context, Timetable old) async {
  if (!canSyncTimetable(old)) return null;
  final newTimetable = await _fetchSameTypeTimetable(old);
  final equal = old.isBasicInfoEqualTo(newTimetable);
  if (!context.mounted) return null;
  if (equal) {
    await context.showTip(
      title: "Already latest",
      desc: "You don't need to update this timetable because it's already the latest",
      primary: "OK",
    );
  } else {
    final confirm = await context.showActionRequest(
      title: "Newest available",
      desc: "The timetable has been updated. Do you want to overwrite your changes and sync with the newest version?",
      action: "Update",
      destructive: true,
      cancel: "Cancel",
      dismissible: false,
    );
    if (confirm == true) {
      final merged = old
          .copyWith(
            lastCourseKey: newTimetable.lastCourseKey,
            courses: newTimetable.courses,
          )
          .markModified();
      return merged;
    }
  }
  return null;
}

Future<void> autoSyncTimetable(BuildContext context, Timetable old) async {
  if (!canSyncTimetable(old)) return;
  final lastSyncTimetableTime = Settings.timetable.lastSyncTimetableTime;
}
