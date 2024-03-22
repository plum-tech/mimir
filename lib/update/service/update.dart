import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sit/files.dart';
import 'package:sit/init.dart';
import 'package:sit/session/backend.dart';
import 'package:sit/utils/error.dart';

import '../entity/artifact.dart';

class UpdateService {
  BackendSession get _session => Init.backend;

  const UpdateService();

  Future<ArtifactVersionInfo> getLatestVersion() async {
    late Response res;
    try {
      res = await _session.get(
        "https://g.mysit.life/artifact/latest.json",
      );
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      res = await _session.get(
        "https://get.mysit.life/artifact/latest.json",
      );
    }
    final json = res.data as Map<String, dynamic>;
    return ArtifactVersionInfo.fromJson(json);
  }

  Future<File> downloadArtifactFromUrl(
    String url, {
    required String name,
    ProgressCallback? onProgress,
  }) async {
    final file = Files.artifact.subFile(name);
    await Init.dio.download(url, file.path, onReceiveProgress: onProgress);
    return file;
  }
}
