import 'package:dio/dio.dart';
import 'package:sit/init.dart';

import 'package:sit/session/jwxt.dart';

import '../entity/exam.dart';
import 'package:sit/school/entity/school.dart';

class ExamArrangeService {
  static const _examRoomUrl = 'http://jwxt.sit.edu.cn/jwglxt/kwgl/kscx_cxXsksxxIndex.html';

  JwxtSession get _session => Init.jwxtSession;

  const ExamArrangeService();

  /// 获取考场信息
  Future<List<ExamEntry>> fetchExamList(SemesterInfo info) async {
    final response = await _session.request(
      _examRoomUrl,
      para: {
        'doType': 'query',
        'gnmkdm': 'N358105',
      },
      data: {
        // 学年名
        'xnm': info.year.toString(),
        // 学期名
        'xqm': semesterToFormField(info.semester),
      },
      options: Options(
        method: "POST",
      ),
    );
    final List<dynamic> itemsData = response.data['items'];
    final list = itemsData.map((e) => ExamEntry.parseRemoteJson(e as Map<String, dynamic>)).toList();
    list.sort(ExamEntry.comparator);
    return list;
  }
}
