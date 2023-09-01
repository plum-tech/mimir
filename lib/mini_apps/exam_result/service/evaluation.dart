import '../dao/evaluation.dart';
import '../entity/evaluation.dart';
import '../using.dart';

class CourseEvaluationService implements CourseEvaluationDao {
  static const _serviceUrl = 'http://jwxt.sit.edu.cn/jwglxt/xspjgl/xspj_cxXspjIndex.html?doType=query&gnmkdm=N401605';
  final ISession session;

  const CourseEvaluationService(this.session);

  List<CourseToEvaluate> _parseEvaluationList(Map<String, dynamic> page) {
    final List evaluationList = page['items'];

    return evaluationList.map((e) => CourseToEvaluate.fromJson(e as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<CourseToEvaluate>> getEvaluationList() async {
    final Map form = {
      '_search': 'false',
      'queryModel.showCount': 100,
      'queryModel.currentPage': '1',
      'queryModel.sortName': '',
      'queryModel.sortOrder': 'asc',
      'time': 0
    };

    final response = await session.request(_serviceUrl, ReqMethod.post, data: form);
    return _parseEvaluationList(response.data);
  }
}
