import 'package:mimir/network/session.dart';
import 'package:mimir/session/ywb.dart';

import '../entity/application.dart';

const String _serviceFunctionList = 'https://xgfy.sit.edu.cn/app/public/queryAppManageJson';
const String _serviceFunctionDetail = 'https://xgfy.sit.edu.cn/app/public/queryAppFormJson';

class ApplicationService {
  final YwbSession session;

  const ApplicationService(this.session);

  Future<List<ApplicationMeta>> getApplicationMetas() async {
    const String payload = '{"appObject":"student","appName":null}';

    final response = await session.request(
      _serviceFunctionList,
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

  Future<ApplicationDetails> getApplicationDetail(String functionId) async {
    final String payload = '{"appID":"$functionId"}';

    final response = await session.request(
      _serviceFunctionDetail,
      ReqMethod.post,
      data: payload,
      options: SessionOptions(responseType: SessionResType.json),
    );
    final Map<String, dynamic> data = response.data;
    final List<ApplicationDetailSection> sections =
        (data['value'] as List<dynamic>).map((e) => ApplicationDetailSection.fromJson(e)).toList();

    return ApplicationDetails(functionId, sections);
  }
}
