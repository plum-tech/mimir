import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mimir/network/session.dart';

import '../entity/message.dart';

const String serviceMessageCount = 'https://xgfy.sit.edu.cn/unifri-flow/user/queryFlowCount';

String _getMessageListUrl(YwbApplicationType type) {
  final method = switch (type) {
    YwbApplicationType.todo => 'Todolist_Init',
    YwbApplicationType.running => 'Runing_Init',
    YwbApplicationType.complete => 'Complete_Init',
  };
  return 'https://xgfy.sit.edu.cn/unifri-flow/WF/Comm/ProcessRequest.do?DoType=HttpHandler&DoMethod=$method&HttpHandlerName=BP.WF.HttpHandler.WF';
}

class YwbApplicationService {
  final ISession session;

  const YwbApplicationService(this.session);

  // Future<ApplicationMessageCount> getMessageCount({
  //   required String oaAccount,
  // }) async {
  //   final response = await session.request(
  //     serviceMessageCount,
  //     ReqMethod.post,
  //     data: "code=$oaAccount",
  //     options: SessionOptions(
  //       contentType: 'application/x-www-form-urlencoded;charset=utf-8',
  //       responseType: ResponseType.json,
  //     ),
  //   );
  //   final Map<String, dynamic> data = response.data;
  //   final ApplicationMessageCount result = ApplicationMessageCount.fromJson(data['data']);
  //   return result;
  // }

  Future<List<YwbApplication>> getApplication(YwbApplicationType type) async {
    final response = await session.request(
      _getMessageListUrl(type),
      ReqMethod.post,
      data: "myFlow=1&pageIdx=1&pageSize=999",
      options: SessionOptions(
        contentType: 'application/x-www-form-urlencoded',
        responseType: ResponseType.json,
      ),
    );
    final List data = jsonDecode(response.data);
    // filter empty application.
    data.retainWhere((e) => (e['WorkID'] as String).isNotEmpty);
    final List<YwbApplication> messages = data.map((e) => YwbApplication.fromJson(e)).toList();
    return messages;
  }

  Future<MyYwbApplications> getMyMessage() async {
    return (
      todo: await getApplication(YwbApplicationType.todo),
      running: await getApplication(YwbApplicationType.running),
      complete: await getApplication(YwbApplicationType.complete),
    );
  }
}
