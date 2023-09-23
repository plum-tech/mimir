import 'package:dio/dio.dart';
import 'package:mimir/network/session.dart';
import 'package:mimir/session/ywb.dart';

import '../entity/meta.dart';

const String _serviceFunctionList = 'https://xgfy.sit.edu.cn/app/public/queryAppManageJson';
const String _serviceFunctionDetail = 'https://xgfy.sit.edu.cn/app/public/queryAppFormJson';

class YwbApplicationMetaService {
  final YwbSession session;

  const YwbApplicationMetaService(this.session);

  Future<List<YwbApplicationMeta>> getApplicationMetas() async {
    const String payload = '{"appObject":"student","appName":null}';

    final response = await session.request(
      _serviceFunctionList,
      ReqMethod.post,
      data: payload,
      options: SessionOptions(responseType: ResponseType.json),
    );

    final Map<String, dynamic> data = response.data;
    final List<YwbApplicationMeta> functionList = (data['value'] as List<dynamic>)
        .map((e) => YwbApplicationMeta.fromJson(e))
        .where((element) => element.status == 1) // Filter functions unavailable.
        .toList();

    return functionList;
  }

  Future<YwbApplicationMetaDetails> getApplicationDetails(String functionId) async {
    final String payload = '{"appID":"$functionId"}';

    final response = await session.request(
      _serviceFunctionDetail,
      ReqMethod.post,
      data: payload,
      options: SessionOptions(responseType: ResponseType.json),
    );
    final Map<String, dynamic> data = response.data;
    final List<YwbApplicationMetaDetailSection> sections =
        (data['value'] as List<dynamic>).map((e) => YwbApplicationMetaDetailSection.fromJson(e)).toList();

    return YwbApplicationMetaDetails(id: functionId, sections: sections);
  }
}
