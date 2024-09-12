import 'package:mimir/credentials/init.dart';
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
  // TimetableInit.service.fetchUgTimetable(info)
}
