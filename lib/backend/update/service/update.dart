import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mimir/init.dart';
import 'package:mimir/utils/error.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:version/version.dart';

import '../entity/artifact.dart';

const _itunesURL = 'https://itunes.apple.com';

class MimirUpdateService {
  Dio get _dio => Init.mimirDio;

  const MimirUpdateService();

  Future<ArtifactVersionInfo> getLatestVersionFromOfficial() async {
    final res = await _dio.get(
      "https://g.mysit.life/v1/preview/latest",
    );
    final json = res.data as Map<String, dynamic>;
    return ArtifactVersionInfo.fromJson(json);
  }

  /// return null if the version from iTunes isn't identical to official's
  Future<ArtifactVersionInfo?> getLatestVersionFromAppStoreAndOfficial() async {
    final official = await getLatestVersionFromOfficial();
    final version = await getLatestVersionFromAppStore();
    if (official.version == version) {
      return official;
    }
    return null;
  }

  Future<Version?> getLatestVersionFromAppStore({String? iosAppStoreRegion = "cn"}) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final version = await _getVersionFromItunes(
      UniversalPlatform.isIOS || UniversalPlatform.isMacOS ? packageInfo.packageName : "life.mysit.SITLife",
      iosAppStoreRegion: iosAppStoreRegion,
    );
    return version;
  }

  Future<Version?> _getVersionFromItunes(String bundleId, {String? iosAppStoreRegion}) async {
    final Uri uri;

    if (iosAppStoreRegion == null) {
      uri = Uri.parse('$_itunesURL/lookup?bundleId=$bundleId');
    } else {
      uri = Uri.parse('$_itunesURL/$iosAppStoreRegion/lookup?bundleId=$bundleId');
    }

    final res = await _dio.requestUri(uri);

    final responseBody = await res.data as String;
    final json = jsonDecode(responseBody);
    final version = _parseVersionFromItunes(json);
    return version;
  }

  Version? _parseVersionFromItunes(Map<String, dynamic> json) {
    final results = json["results"];
    if (results is! List) return null;
    if (results.isEmpty) return null;
    final info = results.first;
    final versionRaw = info["version"];
    if (versionRaw is! String) return null;
    return Version.parse(versionRaw);
  }
}
