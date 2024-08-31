import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mimir/init.dart';

const _base = "https://ocr.mysit.life/v1";

class MimirOcrService {
  Dio get _dio => Init.mimirDio;

  const MimirOcrService();

  Future<String?> recognizeSchoolCaptcha(Uint8List imageData) async {
    final image = base64Encode(imageData);
    try {
      final res = await _dio.post(
        "$_base/school-captcha",
        data: {
          "imageBase64": image,
        },
      );
      final result = res.data;
      if (result["success"]) {
        return result["code"] as String;
      }
      return null;
    } catch (error, stackTrace) {
      return null;
    }
  }
}
