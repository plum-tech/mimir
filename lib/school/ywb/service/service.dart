import 'package:dio/dio.dart';
import 'package:sit/init.dart';

import 'package:sit/session/ywb.dart';

import '../entity/service.dart';

const String _serviceFunctionList = 'https://xgfy.sit.edu.cn/app/public/queryAppManageJson';
const String _serviceFunctionDetail = 'https://xgfy.sit.edu.cn/app/public/queryAppFormJson';

class YwbServiceService {
  YwbSession get session => Init.ywbSession;

  const YwbServiceService();

  Future<List<YwbService>> getServices() async {
    final response = await session.request(
      _serviceFunctionList,
      data: '{"appObject":"student","appName":null}',
      options: Options(
        responseType: ResponseType.json,
        method: "POST",
      ),
    );

    final Map<String, dynamic> data = response.data;
    final List<YwbService> functionList = (data['value'] as List<dynamic>)
        .map((e) => YwbService.fromJson(e))
        .where((element) => element.status == 1) // Filter functions unavailable.
        .toList();

    return functionList;
  }

  Future<YwbServiceDetails> getServiceDetails(String functionId) async {
    final response = await session.request(
      _serviceFunctionDetail,
      data: '{"appID":"$functionId"}',
      options: Options(
        responseType: ResponseType.json,
        method: "POST",
      ),
    );
    final Map<String, dynamic> data = response.data;
    final List<YwbServiceDetailSection> sections =
        (data['value'] as List<dynamic>).map((e) => YwbServiceDetailSection.fromJson(e)).toList();

    return YwbServiceDetails(id: functionId, sections: sections);
  }
}
