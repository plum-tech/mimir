import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/session/gms.dart';
import 'package:sit/session/jwxt.dart';

import '../entity/course.dart';
import '../entity/timetable.dart';

class TimetableService {
  static const _undergraduateTimetableUrl = 'http://jwxt.sit.edu.cn/jwglxt/kbcx/xskbcx_cxXsgrkb.html';

  JwxtSession get jwxtSession => Init.jwxtSession;

  GmsSession get gmsSession => Init.gmsSession;

  const TimetableService();

  /// 获取课表
  Future<SitTimetable> getUndergraduateTimetable(SemesterInfo info) async {
    final response = await jwxtSession.request(
      _undergraduateTimetableUrl,
      ReqMethod.post,
      para: {'gnmkdm': 'N253508'},
      data: {
        // 学年名
        'xnm': info.year.toString(),
        // 学期名
        'xqm': semesterToFormField(info.semester)
      },
    );
    final json = response.data;
    final List<dynamic> courseList = json['kbList'];
    final rawCourses = courseList.map((e) => CourseRaw.fromJson(e)).toList();
    final timetableEntity = SitTimetable.parse(rawCourses);
    return timetableEntity;
  }

  Future<SitTimetable?> getPostgraduateTimetable(SemesterInfo info) async {

  }
}
