import 'package:dio/dio.dart';
import 'package:sit/network/session.dart';

abstract class Downloader {
  Future<void> download(
    String url, {
    String? savePath,
    SessionProgressCallback? onReceiveProgress,
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
  });
}
