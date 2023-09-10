import 'dart:convert';

import 'package:mimir/app.dart';
import "package:mimir/credential/widgets/oa_scope.dart";
import 'package:mimir/network/session.dart';

import '../dao/message.dart';
import '../entity/message.dart';

const String serviceMessageCount = 'https://xgfy.sit.edu.cn/unifri-flow/user/queryFlowCount';

class ApplicationMessageService implements ApplicationMessageDao {
  final ISession session;

  const ApplicationMessageService(this.session);

  @override
  Future<ApplicationMessageCount> getMessageCount() async {
    final account = $Key.currentContext?.auth.credential!.account;
    String payload = 'code=$account';

    final response = await session.request(
      serviceMessageCount,
      ReqMethod.post,
      data: payload,
      options: SessionOptions(
        contentType: 'application/x-www-form-urlencoded;charset=utf-8',
        responseType: SessionResType.json,
      ),
    );
    final Map<String, dynamic> data = response.data;
    final ApplicationMessageCount result = ApplicationMessageCount.fromJson(data['data']);
    return result;
  }

  Future<ApplicationMessagePage> getMessage(ApplicationMessageType type, int page) async {
    final String url = _getMessageListUrl(type);
    final String payload = 'myFlow=1&pageIdx=$page&pageSize=999'; // TODO: 此处硬编码.

    final response = await session.request(
      url,
      ReqMethod.post,
      data: payload,
      options: SessionOptions(
        contentType: 'application/x-www-form-urlencoded',
        responseType: SessionResType.json,
      ),
    );
    final List data = jsonDecode(response.data);
    final int totalNum = int.parse(data.last['totalNum']);
    final int totalPage = int.parse(data.last['totalPage']);
    final List<ApplicationMessage> messages =
        data.where((e) => (e['FlowName'] as String).isNotEmpty).map((e) => ApplicationMessage.fromJson(e)).toList();

    return ApplicationMessagePage(totalNum, totalPage, page, messages);
  }

  @override
  Future<ApplicationMessagePage> getAllMessage() async {
    List<ApplicationMessage> messageList = [];

    for (ApplicationMessageType type in ApplicationMessageType.values) {
      messageList.addAll((await getMessage(type, 1)).msgList);
    }
    // TODO: 此处硬编码.
    return ApplicationMessagePage(messageList.length, 1, 1, messageList);
  }

  static String _getMessageListUrl(ApplicationMessageType type) {
    final method = switch (type) {
      ApplicationMessageType.todo => 'Todolist_Init',
      ApplicationMessageType.doing => 'Runing_Init',
      ApplicationMessageType.done => 'Complete_Init',
    };
    return 'https://xgfy.sit.edu.cn/unifri-flow/WF/Comm/ProcessRequest.do?DoType=HttpHandler&DoMethod=$method&HttpHandlerName=BP.WF.HttpHandler.WF';
  }
}
