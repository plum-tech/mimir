import 'package:mimir/network/session.dart';
import 'package:mimir/session/ywb.dart';

import '../dao/application.dart';
import '../entity/application.dart';

const String serviceFunctionList = 'https://xgfy.sit.edu.cn/app/public/queryAppManageJson';
const String serviceFunctionDetail = 'https://xgfy.sit.edu.cn/app/public/queryAppFormJson';

class ApplicationService implements ApplicationDao {
  final YwbSession session;

  const ApplicationService(this.session);

  @override
  Future<List<ApplicationMeta>> getApplicationMetas() async {
    String payload = '{"appObject":"student","appName":null}';

    final response = await session.request(
      serviceFunctionList,
      ReqMethod.post,
      data: payload,
      options: SessionOptions(responseType: SessionResType.json),
    );

    final Map<String, dynamic> data = response.data;
    final List<ApplicationMeta> functionList = (data['value'] as List<dynamic>)
        .map((e) => ApplicationMeta.fromJson(e))
        .where((element) => element.status == 1) // Filter functions unavailable.
        .toList();

    return functionList;
  }

  @override
  Future<ApplicationDetail> getApplicationDetail(String functionId) async {
    final String payload = '{"appID":"$functionId"}';

    final response = await session.request(
      serviceFunctionDetail,
      ReqMethod.post,
      data: payload,
      options: SessionOptions(responseType: SessionResType.json),
    );
    final Map<String, dynamic> data = response.data;
    final List<ApplicationDetailSection> sections =
        (data['value'] as List<dynamic>).map((e) => ApplicationDetailSection.fromJson(e)).toList();

    return ApplicationDetail(functionId, sections);
  }
}
