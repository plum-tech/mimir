import 'package:mimir/network/session.dart';

import '../entity/exam.dart';
import 'package:mimir/school/entity/school.dart';

class ExamService {
  static const _examRoomUrl = 'http://jwxt.sit.edu.cn/jwglxt/kwgl/kscx_cxXsksxxIndex.html';
  final ISession session;

  const ExamService(this.session);

  /// 获取考场信息
  Future<List<ExamEntry>> getExamList({
    required SchoolYear year,
    required Semester semester,
  }) async {
    var response = await session.request(
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

    return itemsData.map((e) => ExamEntry.fromJson(e as Map<String, dynamic>)).toList();
  }
}
