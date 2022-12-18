import 'dart:async';

import 'package:dio/dio.dart';

import '../module/activity/using.dart';
import 'dio_common.dart';

const String _baseUrl = '${R.kiteDomain}/api/v2';

class KiteSession implements ISession {
  final Dio dio;
  final JwtDao jwtDao;

  KiteSession(
    this.dio,
    this.jwtDao,
  );

  Future<Response> _dioRequest(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Future<Response> normallyRequest() async {
      return await _requestWithoutRetry(
        url,
        method,
        queryParameters: queryParameters,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    return await normallyRequest();
  }

  Future<Response> _requestWithoutRetry(
    String url,
    String method, {
    Map<String, String>? queryParameters,
    data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    String? token = jwtDao.jwtToken;
    final response = await dio.request(
      url.startsWith('http') ? url : _baseUrl + url,
      data: data,
      queryParameters: queryParameters,
      options: (options ?? Options()).copyWith(
        method: method,
        headers: token == null ? null : {'Authorization': 'Bearer $token'},
      ),
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    // 非 json 数据
    if (!(response.headers.value(Headers.contentTypeHeader) ?? '').contains('json')) {
      // 直接返回
      return response;
    }
    final Map<String, dynamic> responseData = response.data;
    if (!responseData.containsKey('code')) return response;
    final responseDataCode = responseData['code'];
    // 请求正常
    if (responseDataCode == 0) {
      // 直接取数据然后返回
      response.data = responseData['data'];
      return response;
    }
    throw KiteApiFormatError(response.data);
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

/// 服务器数据返回格式有误
class KiteApiFormatError implements Exception {
  final dynamic responseData;

  const KiteApiFormatError(this.responseData);

  @override
  String toString() {
    return 'KiteApiFormatError{responseData: $responseData}';
  }
}
