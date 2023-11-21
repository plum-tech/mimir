import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/jwxt.dart';

import '../entity/exam.dart';
import 'package:sit/school/entity/school.dart';

class ExamArrangeService {
  static const _examRoomUrl = 'http://jwxt.sit.edu.cn/jwglxt/kwgl/kscx_cxXsksxxIndex.html';

  JwxtSession get session => Init.jwxtSession;

  const ExamArrangeService();

  /// 获取考场信息
  Future<List<ExamEntry>> getExamList(SemesterInfo info) async {
    final response = await session.request(
      _examRoomUrl,
      ReqMethod.post,
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
    );
    final List<dynamic> itemsData = response.data['items'];
    final list = itemsData.map((e) => ExamEntry.parseRemoteJson(e as Map<String, dynamic>)).toList();
    list.sort(ExamEntry.comparator);
    return list;
  }
}
