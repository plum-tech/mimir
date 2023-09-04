import 'dart:convert';

import 'package:mimir/app.dart';

import '../dao/message.dart';
import '../entity/message.dart';
import '../using.dart';

const String serviceMessageCount = 'https://xgfy.sit.edu.cn/unifri-flow/user/queryFlowCount';

class ApplicationMessageService implements ApplicationMessageDao {
  final ISession session;

  const ApplicationMessageService(this.session);

  @override
  Future<ApplicationMsgCount> getMessageCount() async {
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
    final ApplicationMsgCount result = ApplicationMsgCount.fromJson(data['data']);
    return result;
  }

  Future<ApplicationMsgPage> getMessage(MessageType type, int page) async {
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
    final List<ApplicationMsg> messages =
        data.where((e) => (e['FlowName'] as String).isNotEmpty).map((e) => ApplicationMsg.fromJson(e)).toList();

    return ApplicationMsgPage(totalNum, totalPage, page, messages);
  }

  @override
  Future<ApplicationMsgPage> getAllMessage() async {
    List<ApplicationMsg> messageList = [];

    for (MessageType type in MessageType.values) {
      messageList.addAll((await getMessage(type, 1)).msgList);
    }
    // TODO: 此处硬编码.
    return ApplicationMsgPage(messageList.length, 1, 1, messageList);
  }

  static String _getMessageListUrl(MessageType type) {
    late String method;
    switch (type) {
      case MessageType.todo:
        method = 'Todolist_Init';
        break;
      case MessageType.doing:
        method = 'Runing_Init';
        break;
      case MessageType.done:
        method = 'Complete_Init';
        break;
    }
    return 'https://xgfy.sit.edu.cn/unifri-flow/WF/Comm/ProcessRequest.do?DoType=HttpHandler&DoMethod=$method&HttpHandlerName=BP.WF.HttpHandler.WF';
  }
}
