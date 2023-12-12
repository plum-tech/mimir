import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sit/design/animation/progress.dart';
import 'package:sit/init.dart';

import 'package:sit/session/ywb.dart';

import '../entity/application.dart';

class YwbApplicationService {
  YwbSession get session => Init.ywbSession;

  const YwbApplicationService();

  Future<List<YwbApplication>> getApplicationsOf(
    YwbApplicationType type, {
    void Function(double progress)? onProgress,
  }) async {
    final progress = ProgressWatcher(callback: onProgress);
    final response = await session.request(
      type.messageListUrl,
      data: {
        "myFlow": 1,
        "pageIdx": 1,
        "pageSize": 99,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        method: "POST",
      ),
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
      data: {
        "WorkID": workId,
        "FK_Flow": functionId,
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        method: "POST",
      ),
    );
    final Map payload = jsonDecode(res.data);
    final List trackRaw = payload["Track"];
    final track = trackRaw.map((e) => YwbApplicationTrack.fromJson(e)).toList();
    return track;
  }
}
