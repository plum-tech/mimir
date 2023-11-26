import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sit/design/animation/progress.dart';
import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/ywb.dart';

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
  YwbSession get session => Init.ywbSession;

  const YwbApplicationService();

  Future<List<YwbApplication>> getApplicationsOf(
    YwbApplicationType type, {
    void Function(double progress)? onProgress,
  }) async {
    final progress = ProgressWatcher(callback: onProgress);
    final response = await session.request(
      _getMessageListUrl(type),
      ReqMethod.post,
      data: {
        "myFlow": 1,
        "pageIdx": 1,
        "pageSize": 99,
      },
      options: SessionOptions(contentType: Headers.formUrlEncodedContentType),
    );
    progress.value = 0.2;
    final List data = jsonDecode(response.data);
    // filter empty application
    data.retainWhere((e) => e["WorkID"] is int);
    final List<YwbApplication> messages = data.map((e) => YwbApplication.fromJson(e)).toList();
    final res = <YwbApplication>[];
    for (final msg in messages) {
      final track = await getTrack(workId: msg.workId, functionId: msg.functionId);
      res.add(msg.copyWith(track: track));
      progress.value += 0.8 / messages.length;
    }
    progress.value = 1;
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
      data: {
        "WorkID": workId,
        "FK_Flow": functionId,
      },
      options: SessionOptions(contentType: Headers.formUrlEncodedContentType),
    );
    final Map payload = jsonDecode(res.data);
    final List trackRaw = payload["Track"];
    final track = trackRaw.map((e) => YwbApplicationTrack.fromJson(e)).toList();
    return track;
  }

  Future<MyYwbApplications> getMyApplications({
    void Function(double progress)? onProgress,
  }) async {
    final progress = ProgressWatcher(callback: onProgress);
    return (
      todo: await getApplicationsOf(YwbApplicationType.todo, onProgress: (double p) {
        progress.value = p / 3;
      }),
      running: await getApplicationsOf(YwbApplicationType.running, onProgress: (double p) {
        progress.value = 1 / 3 + p / 3;
      }),
      complete: await getApplicationsOf(YwbApplicationType.complete, onProgress: (double p) {
        progress.value = 2 / 3 + p / 3;
      }),
    );
  }
}
