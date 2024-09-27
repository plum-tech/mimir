import 'package:dio/dio.dart';
import 'package:mimir/init.dart';

import '../entity/stats.dart';

class StatsService {
  Dio get _dio => Init.mimirDio;

  Future<void> uploadStats(List<StatsEntry> list) async {
    final payloads = list.map((entry) => entry.toJson()).toList(growable: false);
    final res = await _dio.post(
      "https://stats.mysit.life/v1/log",
      data: payloads,
    );
  }
}
