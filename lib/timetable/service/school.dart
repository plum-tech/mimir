import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/session/gms.dart';
import 'package:sit/session/jwxt.dart';

import '../entity/course.dart';
import '../entity/timetable.dart';
import '../utils.dart';

class TimetableService {
  static const _undergraduateTimetableUrl = 'http://jwxt.sit.edu.cn/jwglxt/kbcx/xskbcx_cxXsgrkb.html';
  static const _postgraduateTimetableUrl =
      'http://gms.sit.edu.cn/epstar/yjs/T_PYGL_KWGL_WSXK/T_PYGL_KWGL_WSXK_XSKB_NEW.jsp';

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
    final rawCourses = courseList.map((e) => UndergraduateCourseRaw.fromJson(e)).toList();
    final timetableEntity = parseUndergraduateTimetableFromCourseRaw(rawCourses);
    return timetableEntity;
  }

  Future<SitTimetable> getPostgraduateTimetable(SemesterInfo info) async {
    final response = await gmsSession.request(
      _postgraduateTimetableUrl,
      ReqMethod.post,
      data: {
        "excel": "true",
        "XQDM": _toPostgraduateSemesterText(info),
      },
    );
    final htmlContent = response.data;
    final courseList = generatePostgraduateCourseRawsFromHtml(htmlContent);
    final timetableEntity = parsePostgraduateTimetableFromCourseRaw(courseList);
    return timetableEntity;
    //
    // throw Exception("");
  }

  String _toPostgraduateSemesterText(SemesterInfo info) {
    assert(info.semester != Semester.all);
    if (info.semester == Semester.term1) {
      return "${info.year}09";
    } else {
      return "${info.year + 1}02";
    }
  }
}
