import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:mimir/network/session.dart';

import 'dio_common.dart';

class ReportSession extends ISession {
  final Dio dio;

  ReportSession({
    required this.dio,
  });

  /// 获取当前以毫秒为单位的时间戳.
  static String _getTimestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  /// 为时间戳生成签名. 此方案是联鹏习惯的反爬方式.
  String _md5(String s) => md5.convert(const Utf8Encoder().convert(s)).toString();

  String _sign(String u, String t) {
    final hash = _md5('${u}Unifrinew$t').toString().toUpperCase();
    return hash.substring(16, 32) + hash.substring(0, 16);
  }

  Future<Response> _dioRequest(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Options newOptions = options ?? Options();

    // Make default options.
    final String ts = _getTimestamp();
    final username = Auth.oaCredential?.account;
    final String sign = _sign(username ?? '', ts);
    final Map<String, dynamic> newHeaders = {'ts': ts, 'decodes': sign};

    newOptions.headers == null ? newOptions.headers = newHeaders : newOptions.headers?.addAll(newHeaders);
    newOptions.method = method;

    return await dio.request(
      url,
      queryParameters: queryParameters,
      data: data,
      options: newOptions,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Future<SessionRes> request(
    String url,
    ReqMethod method, {
    Map<String, String>? para,
    data,
    SessionOptions? options,
    SessionProgressCallback? onSendProgress,
    SessionProgressCallback? onReceiveProgress,
  }) async {
    Response response = await _dioRequest(
      url,
      method.uppercaseName,
      queryParameters: para,
      data: data,
      options: options?.toDioOptions(),
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response.toMyResponse();
  }
}

class ReportException implements Exception {
  String msg;

  ReportException([this.msg = '']);

  @override
  String toString() {
    return msg;
  }
}
