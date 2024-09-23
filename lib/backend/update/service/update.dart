import 'package:dio/dio.dart';
import 'package:mimir/init.dart';

import '../entity/version.dart';

class MimirUpdateService {
  Dio get _dio => Init.mimirDio;

  const MimirUpdateService();

  Future<VersionInfo> getLatestVersionInfo() async {
    final res = await _dio.get(
      "https://g.mysit.life/v1/preview/latest",
    );
    final json = res.data as Map<String, dynamic>;
    return VersionInfo.fromJson(json);
  }
}
