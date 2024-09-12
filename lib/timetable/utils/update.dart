import 'package:mimir/credentials/init.dart';
import 'package:mimir/school/entity/school.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/timetable/entity/timetable.dart';
import 'package:mimir/timetable/init.dart';

bool canUpdateTimetable(SitTimetable old) {
  final credentials = CredentialsInit.storage.oa.credentials;
  if (credentials == null) return false;
  if (old.studentId != credentials.account) return false;
  if (old.campus != Settings.campus) return false;
  return true;
}

Future<SitTimetable?> updateTimetable(SitTimetable old) async {
  final newTimetable = _fetchSameTypeTimetable(old);
}

Future<SitTimetable> _fetchSameTypeTimetable(SitTimetable old) async {
  final info = SemesterInfo(year: old.schoolYear, semester: old.semester);
  if (old.studentType == StudentType.undergraduate) {
    return await TimetableInit.service.fetchUgTimetable(info);
  } else {
    return await TimetableInit.service.fetchPgTimetable(info);
  }
}
