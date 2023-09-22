import 'package:mimir/network/session.dart';
import 'package:mimir/session/sis.dart';

import '../entity/exam.dart';
import 'package:mimir/school/entity/school.dart';

class ExamArrangeService {
  static const _examRoomUrl = 'http://jwxt.sit.edu.cn/jwglxt/kwgl/kscx_cxXsksxxIndex.html';
  final SisSession session;

  const ExamArrangeService(this.session);

  /// 获取考场信息
  Future<List<ExamEntry>> getExamList({
    required SchoolYear year,
    required Semester semester,
  }) async {
    final response = await session.request(
      _examRoomUrl,
      ReqMethod.post,
      para: {
        'doType': 'query',
        'gnmkdm': 'N358105',
      },
      data: {
        // 学年名
        'xnm': year.toString(),
        // 学期名
        'xqm': semesterToFormField(semester),
      },
    );
    final List<dynamic> itemsData = response.data['items'];
    final list = itemsData.map((e) => ExamEntry.fromJson(e as Map<String, dynamic>)).toList();
    list.sort(ExamEntry.comparator);
    return list;
  }
}
