import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mimir/init.dart';
import 'package:mimir/utils/error.dart';

class AuthSession {
  static final String _ocrServerUrl =
      utf8.decode(base64Decode('aHR0cHM6Ly9hcGkua2l0ZS5zdW5ueXNhYi5jbi9hcGkvb2NyL2NhcHRjaGE='));

  static Dio get dio => Init.dio;

  static Future<String?> recognizeOaCaptcha(Uint8List imageData) async {
    try {
      final response = await dio.post(_ocrServerUrl, data: base64Encode(imageData));
      final result = response.data;
      return result['code'] == 0 ? result['data'] as String? : null;
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      return null;
    }
  }
}
