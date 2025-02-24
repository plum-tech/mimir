import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/school/entity/school.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/timetable/entity/timetable.dart';
import 'package:mimir/timetable/init.dart';
import 'package:mimir/utils/error.dart';

import "../i18n.dart";

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
      title: i18n.import.alreadyLatest,
      desc: i18n.import.alreadyLatestDesc,
      primary: i18n.ok,
    );
    return null;
  }
  final confirm = await context.showActionRequest(
    title: i18n.import.updateAvailable,
    desc: i18n.import.updateAvailableDesc,
    action: i18n.sync,
    cancel: i18n.cancel,
    destructive: true,
    dismissible: false,
  );
  if (confirm != true) return null;
  final merged = old
      .copyWith(
        lastCourseKey: newTimetable.lastCourseKey,
        courses: newTimetable.courses,
      )
      .markModified();
  return merged;
}

Future<void> syncTimetableWithPrompt(
  BuildContext context,
  Timetable old, {
  required ValueChanged<bool> onSyncingState,
}) async {
  try {
    onSyncingState(true);
    final merged = await syncTimetable(context, old);
    if (merged != null) {
      TimetableInit.storage.timetable[old.uuid] = merged;
    }
    onSyncingState(false);
  } catch (error, stackTrace) {
    debugPrintError(error, stackTrace);
    onSyncingState(false);
    if (!context.mounted) return;
    await context.showTip(
      title: i18n.import.failed,
      desc: error is DioException ? i18n.import.networkFailedDesc : i18n.import.failedDesc,
      primary: i18n.ok,
    );
  }
}
