import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sit/network/session.dart';

import '../entity/application.dart';

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
    // filter empty application
    data.retainWhere((e) => e["WorkID"] is int);
    final List<YwbApplication> messages = data.map((e) => YwbApplication.fromJson(e)).toList();
    final res = <YwbApplication>[];
    for (final msg in messages) {
      final track = await getTrack(workId: msg.workId, functionId: msg.functionId);
      res.add(msg.copyWith(track: track));
    }
    return res;
  }

  Future<List<YwbApplicationTrack>> getTrack({
    required int workId,
    required String functionId,
  }) async {
    // Authentication cookie is even not required!
    final res = await session.request(
      "http://ywb.sit.edu.cn/unifri-flow/WF/Comm/ProcessRequest.do?&DoType=HttpHandler&DoMethod=TimeBase_Init&HttpHandlerName=BP.WF.HttpHandler.WF_WorkOpt_OneWork",
      ReqMethod.post,
      data: "WorkID=$workId&FK_Flow=$functionId",
      options: SessionOptions(
        contentType: 'application/x-www-form-urlencoded',
        responseType: ResponseType.json,
      ),
    );
    final Map payload = jsonDecode(res.data);
    final List trackRaw = payload["Track"];
    final track = trackRaw.map((e) => YwbApplicationTrack.fromJson(e)).toList();
    return track;
  }

  Future<MyYwbApplications> getMyApplications() async {
    return (
      todo: await getApplication(YwbApplicationType.todo),
      running: await getApplication(YwbApplicationType.running),
      complete: await getApplication(YwbApplicationType.complete),
    );
  }
}
