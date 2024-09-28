import 'package:dio/dio.dart';
import 'package:mimir/init.dart';

import '../entity/feature.dart';
import '../entity/route.dart';

class StatsService {
  Dio get _dio => Init.mimirDio;

  Future<void> uploadRoute(List<StatsAppRoute> list) async {
    final payloads = list.map((entry) => entry.toJson()).toList(growable: false);
    final res = await _dio.post(
      "https://stats.mysit.life/v1/log/app-route",
      data: payloads,
    );
  }

  Future<void> uploadFeature(List<StatsAppFeature> list) async {
    final payloads = list.map((entry) => entry.toJson()).toList(growable: false);
    final res = await _dio.post(
      "https://stats.mysit.life/v1/log/app-feature",
      data: payloads,
    );
  }
}
