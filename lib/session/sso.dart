import 'dart:math';

import 'package:async_locks/async_locks.dart';
import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:collection/collection.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Key;
import 'package:logger/logger.dart';
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/error.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/init.dart';
import 'package:sit/lifecycle.dart';
import 'package:sit/r.dart';

import 'package:sit/session/auth.dart';
import 'package:sit/utils/error.dart';
import 'package:sit/utils/riverpod.dart';
import 'package:encrypt/encrypt.dart';

import '../utils/dio.dart';

class LoginCaptchaCancelledException implements Exception {
  const LoginCaptchaCancelledException();
}

class OaCredentialsRequiredException implements Exception {
  final String url;

  const OaCredentialsRequiredException({required this.url});

  @override
  String toString() {
    return "OaCredentialsRequiredException: $url";
  }
}

const _neededHeaders = {
  "Accept-Encoding": "gzip, deflate, br",
  'Origin': 'https://authserver.sit.edu.cn',
  "Upgrade-Insecure-Requests": "1",
  "Sec-Fetch-Dest": "document",
  "Sec-Fetch-Mode": "navigate",
  "Sec-Fetch-Site": "same-origin",
  "Sec-Fetch-User": "?1",
  "Referer": "https://authserver.sit.edu.cn/authserver/login",
};

final networkLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 8,
    // Number of method calls to be displayed
    errorMethodCount: 8,
    // Print an emoji for each log message
    printTime: true, // Should each log print contain a timestamp
  ),
);

/// Single Sign-On
class SsoSession {
  static const String _authServerUrl = 'https://authserver.sit.edu.cn/authserver';
  static const String _loginUrl = '$_authServerUrl/login';
  static const String _needCaptchaUrl = '$_authServerUrl/needCaptcha.html';
  static const String _captchaUrl = '$_authServerUrl/captcha.html';
  static const String _loginSuccessUrl = 'https://authserver.sit.edu.cn/authserver/index.do';

  final Dio dio;
  final CookieJar cookieJar;

  /// Input captcha manually
  final Future<String?> Function(Uint8List imageBytes) inputCaptcha;

  /// Lock it to prevent simultaneous login.
  static final _loginLock = Lock();

  /// Lock all requests through SSO.
  static final _ssoLock = Lock();

  SsoSession({
    required this.dio,
    required this.cookieJar,
    required this.inputCaptcha,
  });

  /// - User try to log in actively on a login page.
  Future<Response> loginLocked(Credentials credentials) async {
    return await _loginLock.run(() async {
      networkLogger.i("loginLocked ${DateTime.now().toIso8601String()}");
      try {
        final byAutoCaptcha = await _login(
          credentials: credentials,
          inputCaptcha: (captchaImage) => AuthSession.recognizeOaCaptcha(captchaImage),
        );
        return byAutoCaptcha;
      } catch (error, stackTrace) {
        debugPrintError(error, stackTrace);
      }
      final byManualCaptcha = await _login(
        credentials: credentials,
        inputCaptcha: inputCaptcha,
      );
      return byManualCaptcha;
    });
  }

  Future<Response> _request(
    String url, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    options ??= Options();
    final debugDepths = <Response>[];
    Future<Response> requestNormally() async {
      final response = await dio.request(
        url,
        queryParameters: queryParameters,
        options: options?.copyWith(
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
        response,
        headers: _neededHeaders,
        debugDepths: debugDepths,
      );
      return finalResponse;
    }

    // request normally at first
    final firstResponse = await requestNormally();

    // check if the response is the login page. if so, login it first.
    if (firstResponse.realUri.toString().contains(_loginUrl)) {
      final credentials = CredentialsInit.storage.oaCredentials;
      if (credentials == null) {
        throw OaCredentialsRequiredException(url: url);
      }
      await cookieJar.delete(Uri.parse(url), true);
      await loginLocked(credentials);
      debugDepths.clear();
      return await requestNormally();
    } else {
      return firstResponse;
    }
  }

  void _setOnline(bool isOnline) {
    final ctx = $key.currentContext;
    if (ctx != null && ctx.mounted) {
      ctx.riverpod().read($oaOnline.notifier).state = isOnline;
    }
  }

  Future<Cookie?> getJSessionId() async {
    final cookies = await Init.cookieJar.loadForRequest(Uri.parse(_authServerUrl));
    return cookies.firstWhereOrNull((cookie) => cookie.name == "JSESSIONID");
  }

  Future<Response> _login({
    required Credentials credentials,
    required Future<String?> Function(Uint8List imageBytes) inputCaptcha,
  }) async {
    debugPrint('${credentials.account} logging in');
    debugPrint('UA: ${dio.options.headers['User-Agent']}');
    // When logging into OA,
    // the server will record the number of times a user has logged in with the same cookie
    // and the number of times the user made an input error,
    // so it is necessary to clear all cookies before logging in to avoid errors when the user retries.
    await cookieJar.delete(R.authServerUri, true);
    // await cookieJar.delete(R.authServerUri, true);
    final Response response;
    try {
      // 首先获取AuthServer首页
      final html = await _fetchAuthServerHtml();
      var captcha = '';
      if (await isCaptchaRequired(credentials.account)) {
        final captchaImage = await getCaptcha();
        final c = await inputCaptcha(captchaImage);
        if (c != null) {
          captcha = c;
          debugPrint("Captcha entered is $captcha");
        } else {
          throw const LoginCaptchaCancelledException();
        }
      }
      // 获取casTicket
      final casTicket = _extractCasTicketFromAuthHtml(html);
      // 获取salt
      final salt = _extractSaltFromAuthHtml(html);
      // 加密密码
      final hashedPwd = _hashPassword(salt, credentials.password);
      // 登录系统，获得cookie
      response = await _postLoginRequest(credentials.account, hashedPwd, captcha, casTicket);
    } catch (e) {
      _setOnline(false);
      rethrow;
    }
    final pageRaw = response.data as String;
    if (pageRaw.contains("完善资料")) {
      throw CredentialsException(message: pageRaw, type: CredentialsErrorType.oaIncompleteUserInfo);
    }
    final page = BeautifulSoup(pageRaw);
    // For desktop
    final authError = page.find('span', id: 'msg', class_: 'auth_error')?.text.trim() ?? "";
    // For mobile
    final mobileError = page.find('span', id: 'errorMsg')?.text.trim() ?? "";
    if (authError.isNotEmpty || mobileError.isNotEmpty) {
      final errorMessage = authError + mobileError;
      final type = _parseInvalidType(errorMessage);
      _setOnline(false);
      throw CredentialsException(message: errorMessage, type: type);
    }

    if (response.realUri.toString() != _loginSuccessUrl) {
      debugPrint('Unknown auth error at "${response.realUri}"');
      _setOnline(false);
      throw Exception(response.data.toString());
    }
    debugPrint('${credentials.account} logged in');
    CredentialsInit.storage.oaLastAuthTime = DateTime.now();
    _setOnline(true);
    return response;
  }

  Future<void> deleteSitUriCookies() async {
    for (final uri in R.sitUriList) {
      await cookieJar.delete(uri, true);
    }
  }

  static CredentialsErrorType _parseInvalidType(String errorMessage) {
    if (errorMessage.contains("验证码")) {
      return CredentialsErrorType.captcha;
    } else if (errorMessage.contains("冻结")) {
      return CredentialsErrorType.oaFrozen;
    } else if (errorMessage.contains("锁定")) {
      return CredentialsErrorType.oaLocked;
    }
    return CredentialsErrorType.accountPassword;
  }

  /// Extract the Salt from the auth page
  String _extractSaltFromAuthHtml(String htmlText) {
    final a = RegExp(r'var pwdDefaultEncryptSalt = "(.*?)";');
    final matchResult = a.firstMatch(htmlText)!.group(0)!;
    final salt = matchResult.substring(29, matchResult.length - 2);
    debugPrint('Salt: $salt');
    return salt;
  }

  /// Extract the CAS ticket from the auth page
  String _extractCasTicketFromAuthHtml(String htmlText) {
    final a = RegExp(r'<input type="hidden" name="lt" value="(.*?)"');
    final matchResult = a.firstMatch(htmlText)!.group(0)!;
    final casTicket = matchResult.substring(38, matchResult.length - 1);
    debugPrint('CAS Ticket: $casTicket');
    return casTicket;
  }

  /// Fetch the auth page, where the account, password and captcha box are.
  Future<String> _fetchAuthServerHtml() async {
    final response = await dio.get(
      _loginUrl,
      options: Options(headers: Map.from(_neededHeaders)..remove('Referer')),
    );
    return response.data;
  }

  /// check if captcha is required for this logging in
  Future<bool> isCaptchaRequired(String username) async {
    final response = await dio.get(
      _needCaptchaUrl,
      queryParameters: {
        'username': username,
        'pwdEncrypt2': 'pwdEncryptSalt',
      },
      options: Options(headers: _neededHeaders),
    );
    final needCaptcha = response.data == 'true';
    debugPrint('Account: $username, Captcha required: $needCaptcha');
    return needCaptcha;
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

  /// Login the single sign-on
  Future<Response> _postLoginRequest(String username, String hashedPassword, String captcha, String casTicket) async {
    // Login
    final res = await dio.post(
      _loginUrl,
      data: {
        'username': username,
        'password': hashedPassword,
        'captchaResponse': captcha,
        'lt': casTicket,
        'dllt': 'userNamePasswordLogin',
        'execution': 'e1s1',
        '_eventId': 'submit',
        'rmShown': '1',
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 400;
        },
        headers: _neededHeaders,
      ),
    );
    final debugDepths = <Response>[];
    final finalResponse = await processRedirect(
      dio,
      res,
      headers: _neededHeaders,
      debugDepths: debugDepths,
    );
    return finalResponse;
  }

  Future<Response> request(
    String url, {
    Map<String, String>? para,
    data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    networkLogger.i("$SsoSession.request ${DateTime.now().toIso8601String()}");
    return await _ssoLock.run<Response>(() async {
      networkLogger.i("$SsoSession.request-locked ${DateTime.now().toIso8601String()}");
      try {
        return await _request(
          url,
          queryParameters: para,
          data: data,
          options: options,
        );
      } catch (error, stackTrace) {
        debugPrintError(error, stackTrace);
        rethrow;
      }
    });
  }
}

String _hashPassword(String salt, String password) {
  var iv = _rds(16);
  var encrypt = _SsoEncryption(salt, iv);
  return encrypt.aesEncrypt(_rds(64) + password);
}

final _rand = Random.secure();

String _rds(int num) {
  const chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678';
  final s = StringBuffer();
  for (var i = 0; i < num; i++) {
    s.write(chars[_rand.nextInt(chars.length)]);
  }
  return s.toString();
}

class _SsoEncryption {
  Key? _key;
  IV? _iv;

  _SsoEncryption(String key, String iv) {
    _key = Key.fromUtf8(key);
    _iv = IV.fromUtf8(iv);
  }

  String aesEncrypt(String content) {
    return Encrypter(
      AES(
        _key!,
        mode: AESMode.cbc,
        padding: 'PKCS7',
      ),
    )
        .encrypt(
          content,
          iv: _iv,
        )
        .base64;
  }
}
