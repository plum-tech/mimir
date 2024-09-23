import 'package:dio/dio.dart';
import 'package:mimir/backend/update/entity/channel.dart';
import 'package:mimir/init.dart';

import '../entity/version.dart';

class MimirUpdateService {
  Dio get _dio => Init.mimirDio;

  const MimirUpdateService();

  Future<VersionInfo> getLatestVersionInfo({
    UpdateChannel channel = UpdateChannel.release,
  }) async {
    final res = await _dio.get(
      "https://g.mysit.life/v1/${channel.name}/latest",
    );
    final json = res.data as Map<String, dynamic>;
    return VersionInfo.fromJson(json);
  }
}
