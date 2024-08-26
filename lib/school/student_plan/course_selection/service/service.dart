import 'package:mimir/init.dart';
import 'package:mimir/session/ug_registration.dart';

class CourseSelectionService {
  UgRegistrationSession get _session => Init.ugRegSession;

  Future<dynamic> fetchTimetableList() async {}
}
