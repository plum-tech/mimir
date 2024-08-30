import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:mimir/init.dart';
import 'package:mimir/session/mimir.dart';

const _base = "https://ocr.mysit.life/v1";

class MimirOcrService {
  MimirSession get _session => Init.mimirSession;

  const MimirOcrService();

  Future<String?> recognizeSchoolCaptcha(Uint8List imageData) async {
    final image = base64Encode(imageData);
    try {
      final res = await _session.request(
        "$_base/school-captcha",
        data: {
          "imageBase64": image,
        },
        options: Options(
          method: "POST",
        ),
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
