import 'dart:convert';

import 'package:sit/init.dart';
import 'package:sit/session/backend.dart';

import '../entity/artifact.dart';

class UpdateService {
  BackendSession get _session => Init.backend;

  const UpdateService();

  Future<ArtifactVersionInfo> getLatestVersion() async {
    final res = await _session.get(
      "https://get.mysit.life/artifact/latest.json",
    );
    final json = jsonDecode(res.data);
    return ArtifactVersionInfo.fromJson(json);
  }
}
