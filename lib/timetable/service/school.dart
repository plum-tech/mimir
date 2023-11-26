import 'package:dio/dio.dart';
import 'package:sit/init.dart';

import 'package:sit/school/entity/school.dart';
import 'package:sit/session/gms.dart';
import 'package:sit/session/jwxt.dart';
import 'package:sit/settings/settings.dart';

import '../../school/exam_result/utils.dart';
import '../entity/course.dart';
import '../entity/timetable.dart';
import '../utils.dart';

class TimetableService {
  static const _undergraduateTimetableUrl = 'http://jwxt.sit.edu.cn/jwglxt/kbcx/xskbcx_cxXsgrkb.html';
  static const _postgraduateTimetableUrl =
      'http://gms.sit.edu.cn/epstar/yjs/T_PYGL_KWGL_WSXK/T_PYGL_KWGL_WSXK_XSKB_NEW.jsp';
  static const _postgraduateScoresUrl = "http://gms.sit.edu.cn/epstar/app/template.jsp";

  JwxtSession get jwxtSession => Init.jwxtSession;

  GmsSession get gmsSession => Init.gmsSession;

  const TimetableService();

  /// 获取本科生课表
  Future<SitTimetable> getUndergraduateTimetable(SemesterInfo info) async {
    final response = await jwxtSession.request(
      _undergraduateTimetableUrl,
      options: Options(
        method: "POST",
      ),
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

  /// 获取研究生课表
  Future<SitTimetable> getPostgraduateTimetable(SemesterInfo info) async {
    final timetableRes = await gmsSession.request(
      _postgraduateTimetableUrl,
      options: Options(
        method: "POST",
      ),
      data: {
        "excel": "true",
        "XQDM": _toPostgraduateSemesterText(info),
      },
    );
    final scoresRes = await gmsSession.request(
      _postgraduateScoresUrl,
      options: Options(
        method: "GET",
      ),
      para: {
        "mainobj": "YJSXT/PYGL/CJGLST/V_PYGL_CJGL_KSCJHZB",
        "tfile": "KSCJHZB_CJCX_CD/KSCJHZB_XSCX_CD_BD",
      },
    );
    final timetableHtmlContent = timetableRes.data;
    final scoresHtmlContent = scoresRes.data;
    final scoreList = parsePostgraduateScoreRawFromScoresHtml(scoresHtmlContent);
    final courseList = parsePostgraduateCourseRawsFromHtml(timetableHtmlContent);
    completePostgraduateCourseRawsFromPostgraduateScoreRaws(courseList, scoreList);
    final timetableEntity = parsePostgraduateTimetableFromCourseRaw(
      courseList,
      campus: Settings.campus,
    );
    return timetableEntity;
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
