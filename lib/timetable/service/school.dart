import 'dart:io';

import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/session/gms.dart';
import 'package:sit/session/jwxt.dart';
import 'package:html/parser.dart';

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
    if (response.statusCode == 200) {
      final htmlContent = response.data;
      final courseList = parseTimeTable(htmlContent);
    }

    throw Exception("");
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

class Course {
  late String name;
  late String time;
  late String location;
  late String teacher;
  late String weekday;
  late String code;
}

List parseTimeTable(String htmlContent) {
  var courseList = [];
  const mapOfWeekday = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];

  void processNodes(List nodes, String weekday) {
    if (nodes.length < 5) {
      // 如果节点数量小于 5，不足以构成一个完整的 Course，忽略
      return;
    }

    var locationWithTeacherStr = nodes[4].text;
    var locationWithTeacherList = locationWithTeacherStr.split("  ");
    var location = locationWithTeacherList[0];
    var teacher = locationWithTeacherList[1];

    final course = Course()
      ..name = nodes[0].text
      ..time = nodes[2].text
      ..location = location
      ..teacher = teacher
      ..weekday = weekday;

    courseList.add(course);

    // 移除处理过的节点，继续处理剩余的节点
    nodes.removeRange(0, 7);

    if (nodes.isNotEmpty) {
      processNodes(nodes, weekday);
    }
  }

  final document = parse(htmlContent);
  final table = document.querySelector('table');
  final trList = table?.querySelectorAll('tr');
  for (var tr in trList!) {
    final tdList = tr.querySelectorAll('td');
    for (var td in tdList) {
      if (td.innerHtml.contains("br")) {
        var index = tdList.indexOf(td);
        String weekday;
        if (tdList.length > 8) {
          weekday = mapOfWeekday[index - 2];
        } else {
          weekday = mapOfWeekday[index - 1];
        }
        var nodes = td.nodes;
        processNodes(nodes, weekday);
      }
    }
  }
  return courseList;
}
