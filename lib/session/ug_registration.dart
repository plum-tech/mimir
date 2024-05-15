import 'dart:convert';
import 'dart:math';

import 'package:async_locks/async_locks.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hashlib_codecs/hashlib_codecs.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:pointycastle/export.dart';
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/init.dart';
import 'package:sit/lifecycle.dart';
import 'package:sit/r.dart';

import 'package:sit/session/sso.dart';
import 'package:sit/utils/dio.dart';

import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:pointycastle/api.dart';
import 'package:pointycastle/asymmetric/rsa.dart';

import 'auth.dart';

const _pubKeUrl = "http://jwxt.sit.edu.cn/xtgl/login_getPublicKey.html";

const _captchaUrl = "http://jwxt.sit.edu.cn/jwglxt/kaptcha";

const _loginEntryUrl = "http://jwxt.sit.edu.cn/jwglxt/xtgl/login_slogin.html";

typedef _PubKey = ({String modulus, String exponent});

/// jwxt.sit.edu.cn
/// Student registration system for undergraduate
class UgRegistrationSession {
  final SsoSession ssoSession;
  final Dio dio;
  final Future<String?> Function(Uint8List imageBytes) inputCaptcha;
  static final _loginLock = Lock();

  const UgRegistrationSession({
    required this.dio,
    required this.ssoSession,
    required this.inputCaptcha,
  });

  Future<void> refreshCookie() async {
    await Init.cookieJar.delete(R.ugRegUri, true);
    // await loginLocked(CredentialsInit.storage.oaCredentials!);
    await ssoSession.request(
      'http://jwxt.sit.edu.cn/sso/jziotlogin',
      options: Options(
        method: "GET",
      ),
    );
  }

  bool _isRedirectedToLoginPage(Response response) {
    final realPath = response.realUri.path;
    return realPath.endsWith('jwglxt/xtgl/login_slogin.html');
  }

  Future<Response> request(String url, {
    Map<String, String>? queryParameters,
    data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    options ??= Options();
    // TODO: is this really necessary?
    options.contentType = 'application/x-www-form-urlencoded;charset=utf-8';
    Future<Response> fetch() async {
      // return await _request(
      return await ssoSession.request(
        url,
        queryParameters: queryParameters,
        data: data,
        options: options?.copyWith(
          followRedirects: false,
          validateStatus: (status) {
            return status! < 400;
          },
        ),
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    final response = await fetch();
    if (_isRedirectedToLoginPage(response)) {
      debugPrint('JwxtSession requires login');
      await refreshCookie();
      return await fetch();
    }
    return response;
  }

  Future<Response> _request(String url, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    options ??= Options();
    options.contentType = 'application/x-www-form-urlencoded;charset=utf-8';

    final debugDepths = <Response>[];
    final res = await dio.request(
      url,
      queryParameters: queryParameters,
      options: options.copyWith(
        followRedirects: false,
        validateStatus: (status) {
          return status! < 400;
        },
      ),
      data: data,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    final finalResponse = await processRedirect(
      dio,
      res,
      debugDepths: debugDepths,
      headers: _neededHeaders,
    );
    return finalResponse;
  }

  Future<bool> checkConnectivity({
    String url = 'http://jwxt.sit.edu.cn/',
  }) async {
    try {
      await Init.dioNoCookie.request(
        url,
        options: Options(
          method: "GET",
          sendTimeout: const Duration(milliseconds: 3000),
          receiveTimeout: const Duration(milliseconds: 3000),
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (status) => status! < 400,
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Response> loginLocked(Credentials credentials) async {
    return await _loginLock.run(() async {
      return await _login(
        credentials,
        inputCaptcha: (captchaImage) => AuthSession.recognizeOaCaptcha(captchaImage),
        // inputCaptcha: inputCaptcha,
      );
    });
  }

  Future<Response> _login(Credentials credentials, {
    required Future<String?> Function(Uint8List imageBytes) inputCaptcha,
  }) async {
    final entryRes = await Init.dio.request(
      _loginEntryUrl,
    );
    final pubKeySplit = await _getPubKeySplit();
    final pubKey = RSAPublicKey(
      _base64ToBigInt(pubKeySplit.modulus),
      _base64ToBigInt(pubKeySplit.exponent),
    );
    final encryptedPwd = _encryptPassword(credentials.password, pubKeySplit, pubKey);
    final csrfToken = extractCsrfToken(entryRes.data);

    final captchaImage = await getCaptcha();
    await $key.currentContext!.showAnyTip(
      make: (ctx) =>
          Image.memory(
            captchaImage,
            scale: 0.5,
          ),
      primary: "OK",
    );
    final captcha = await getInputtedCaptcha(captchaImage, inputCaptcha);
    final logoutRes = await dio.request(
      "http://jwxt.sit.edu.cn/jwglxt/xtgl/login_logoutAccount.html",
      options: Options(
        method: "POST",
      ),
    );
    final loginRes = await dio.request(
      _loginEntryUrl,
      queryParameters: {
        "time": DateTime
            .now()
            .millisecondsSinceEpoch,
      },
      data: 'csrftoken=$csrfToken&language=zh_CN&yhm=${credentials.account}&mm=$encryptedPwd&yzm=$captcha',
      options: Options(
        method: "POST",
        contentType: 'application/x-www-form-urlencoded;charset=utf-8',
        headers: _neededHeaders,
      ),
    );
    return loginRes;
  }

  Future<String> getInputtedCaptcha(Uint8List captchaImage,
      Future<String?> Function(Uint8List imageBytes) inputCaptcha,) async {
    final c = await inputCaptcha(captchaImage);
    if (c != null) {
      debugPrint("Captcha entered is $c");
      return c;
    } else {
      throw const LoginCaptchaCancelledException();
    }
  }

  Future<Uint8List> getCaptcha() async {
    final response = await dio.get(
      _captchaUrl,
      options: Options(
        responseType: ResponseType.bytes,
        headers: _neededHeaders,
      ),
    );
    Uint8List captchaData = response.data;
    return captchaData;
  }

  String extractCsrfToken(String html) {
    final soup = BeautifulSoup(html);
    final tokenRaw = soup.find("input", id: "csrftoken")!;
    final token = tokenRaw.getAttrValue("value")!;
    return token;
  }

  Future<_PubKey> _getPubKeySplit() async {
    final res = await dio.request(
      _pubKeUrl,
      queryParameters: {
        "time": DateTime
            .now()
            .millisecondsSinceEpoch,
      },
      options: Options(
        headers: _neededHeaders,
      ),
    );
    final json = res.data;
    final modulus = json["modulus"] as String;
    final exponent = json["exponent"] as String;
    return (modulus: modulus, exponent: exponent);
  }
}

String _encryptPassword(String password, _PubKey pubKeySplit, RSAPublicKey pubKey) {
  final rsa = RSA(publicKey: pubKey);
  final encrypter = Encrypter(rsa);
  final encryptedPwd = encrypter
      .encrypt(password)
      .base64;
  return encryptedPwd;
}

String _encryptPassword2(String password, _PubKey pubKeySplit, RSAPublicKey pubKey) {
  return encrypt(password, pubKeySplit.modulus);
}

String encrypt(String plaintext, String publicKey) {
  var modulusBytes = base64.decode(publicKey);
  var modulus = BigInt.parse(hex.encode(modulusBytes), radix: 16);
  var exponent = BigInt.parse(hex.encode(base64.decode('AQAB')), radix: 16);
  var engine = RSAEngine()
    ..init(
      true,
      PublicKeyParameter<RSAPublicKey>(RSAPublicKey(modulus, exponent)),
    );

  //PKCS1.5 padding
  var k = modulusBytes.length;
  var plainBytes = utf8.encode(plaintext);
  var paddingLength = k - 3 - plainBytes.length;
  var eb = Uint8List(paddingLength + 3 + plainBytes.length);
  var r = Random.secure();
  eb.setRange(paddingLength + 3, eb.length, plainBytes);
  eb[0] = 0;
  eb[1] = 2;
  eb[paddingLength + 2] = 0;
  for (int i = 2; i < paddingLength + 2; i++) {
    eb[i] = r.nextInt(254) + 1;
  }

  print(plainBytes.length);
  print(eb);

  return base64.encode(
    engine.process(eb),
  );
}

BigInt _pkcs1pad2(String s, int n) {
  if (n < s.length + 11) {
    throw ArgumentError('Message too long for RSA');
  }
  final List<int> ba = List<int>.filled(n, 0); // Initialize with zeros
  int i = s.length - 1;
  int j = n - 1;
  while (i >= 0 && j > 0) {
    int c = s.codeUnitAt(i--);
    if (c < 128) {
      ba[j--] = c;
    } else if (c < 2048) {
      ba[j--] = (c & 0x3F) | 0x80;
      ba[j--] = (c >> 6) | 0xC0;
    } else {
      ba[j--] = (c & 0x3F) | 0x80;
      ba[j--] = ((c >> 6) & 0x3F) | 0x80;
      ba[j--] = (c >> 12) | 0xE0;
    }
  }
  ba[j--] = 0;
  final rng = Random();
  while (j > 1) {
    int x = rng.nextInt(256); // Generate random non-zero byte
    ba[j--] = x;
  }
  ba[j--] = 2;
  ba[j] = 0;
  return _convertBytesToBigInt(Uint8List.fromList(ba));
}

/// Converts a [Uint8List] byte buffer into a [BigInt]
BigInt _convertBytesToBigInt(Uint8List bytes) {
  BigInt result = BigInt.zero;

  for (final byte in bytes) {
// reading in big-endian, so we essentially concat the new byte to the end
    result = (result << 8) | BigInt.from(byte);
  }
  return result;
}

BigInt _base64ToBigInt(String base64Encoded) {
  final bytes = fromBase64(base64Encoded);
  final hex = toHex(bytes);
  return BigInt.parse(hex, radix: 16);
}

const _neededHeaders = {
  "Accept-Encoding": "gzip, deflate, br",
  'Origin': 'http://jwxt.sit.edu.cn',
  "Connection": "keep-alive",
  "Upgrade-Insecure-Requests": "1",
  "Cache-Control": "no-cache",
  "Pragma": "no-cache",
  "DNT": "1",
  "Referer": _loginEntryUrl,
};
