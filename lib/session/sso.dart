import 'dart:math';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:collection/collection.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' hide Key;
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/error.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/init.dart';
import 'package:sit/r.dart';

import 'package:sit/route.dart';
import 'package:sit/session/auth.dart';
import 'package:sit/session/widgets/scope.dart';
import 'package:sit/utils/error.dart';
import 'package:synchronized/synchronized.dart';
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

/// Single Sign-On
class SsoSession {
  static const String _authServerUrl = 'https://authserver.sit.edu.cn/authserver';
  static const String _loginUrl = '$_authServerUrl/login';
  static const String _needCaptchaUrl = '$_authServerUrl/needCaptcha.html';
  static const String _captchaUrl = '$_authServerUrl/captcha.html';
  static const String _loginSuccessUrl = 'https://authserver.sit.edu.cn/authserver/index.do';

  final Dio dio;
  final CookieJar cookieJar;

  /// Session错误拦截器
  final void Function(Object error, StackTrace stackTrace)? onError;

  /// 手动验证码
  final Future<String?> Function(Uint8List imageBytes) inputCaptcha;

  /// Lock it to prevent simultaneous login.
  final loginLock = Lock();

  SsoSession({
    required this.dio,
    required this.cookieJar,
    required this.inputCaptcha,
    this.onError,
  });

  Future<bool> checkConnectivity({
    String url = 'http://jwxt.sit.edu.cn/',
  }) async {
    try {
      await _dioRequest(
        url,
        options: Options(
          method: "GET",
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

  /// 判断该请求是否为登录页
  bool isLoginPage(Response response) {
    return response.realUri.toString().contains(_loginUrl);
  }

  /// - User try to log in actively on a login page.
  Future<Response> loginLocked(Credentials credentials) async {
    return await loginLock.synchronized(() async {
      try {
        final autoCaptcha = await _login(
          credentials: credentials,
          inputCaptcha: (captchaImage) => AuthSession.recognizeOaCaptcha(captchaImage),
        );
        return autoCaptcha;
      } catch (error, stackTrace) {
        debugPrintError(error, stackTrace);
      }
      final manuallyCaptcha = await _login(
        credentials: credentials,
        inputCaptcha: inputCaptcha,
      );
      return manuallyCaptcha;
    });
  }

  Future<Response> _dioRequest(
    String url, {
    Map<String, String>? queryParameters,
    dynamic data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      return await _request(
        url,
        queryParameters: queryParameters,
        data: data,
        options: options,
      );
    } catch (error, stackTrace) {
      onError?.call(error, stackTrace);
      rethrow;
    }
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

    /// 正常地请求
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
      // 处理重定向
      return await processRedirect(dio, response, headers: _neededHeaders);
    }

    // 第一次先正常请求
    final firstResponse = await requestNormally();

    // 如果跳转登录页，那就先登录
    if (isLoginPage(firstResponse)) {
      final credentials = CredentialsInit.storage.oaCredentials;
      if (credentials == null) {
        throw OaCredentialsRequiredException(url: url);
      }
      await loginLocked(credentials);
      return await requestNormally();
    } else {
      return firstResponse;
    }
  }

  void _setOnline(bool isOnline) {
    final ctx = $Key.currentContext;
    if (ctx != null && ctx.mounted) {
      OaOnlineManagerState.of(ctx).isOnline = isOnline;
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
    await deleteSitUriCookies();
    // await cookieJar.delete(R.authServerUri, true);
    final Response response;
    try {
      // 首先获取AuthServer首页
      final html = await _getAuthServerHtml();
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
      final casTicket = _getCasTicketFromAuthHtml(html);
      // 获取salt
      final salt = _getSaltFromAuthHtml(html);
      // 加密密码
      final hashedPwd = hashPassword(salt, credentials.password);
      // 登录系统，获得cookie
      response = await _postLoginRequest(credentials.account, hashedPwd, captcha, casTicket);
    } catch (e) {
      _setOnline(false);
      rethrow;
    }
    final page = BeautifulSoup(response.data);

    final emptyPage = BeautifulSoup('');
    // For desktop
    final authError = (page.find('span', id: 'msg', class_: 'auth_error') ?? emptyPage).text.trim();
    // For mobile
    final mobileError = (page.find('span', id: 'errorMsg') ?? emptyPage).text.trim();
    if (authError.isNotEmpty || mobileError.isNotEmpty) {
      final errorMessage = authError + mobileError;
      final type = parseInvalidType(errorMessage);
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

  static CredentialsErrorType parseInvalidType(String errorMessage) {
    if (errorMessage.contains("验证码")) {
      return CredentialsErrorType.captcha;
    } else if (errorMessage.contains("冻结")) {
      return CredentialsErrorType.frozen;
    }
    return CredentialsErrorType.accountPassword;
  }

  /// 提取认证页面中的加密盐
  String _getSaltFromAuthHtml(String htmlText) {
    final a = RegExp(r'var pwdDefaultEncryptSalt = "(.*?)";');
    final matchResult = a.firstMatch(htmlText)!.group(0)!;
    final salt = matchResult.substring(29, matchResult.length - 2);
    debugPrint('Salt: $salt');
    return salt;
  }

  /// 提取认证页面中的Cas Ticket
  String _getCasTicketFromAuthHtml(String htmlText) {
    final a = RegExp(r'<input type="hidden" name="lt" value="(.*?)"');
    final matchResult = a.firstMatch(htmlText)!.group(0)!;
    final casTicket = matchResult.substring(38, matchResult.length - 1);
    debugPrint('CAS Ticket: $casTicket');
    return casTicket;
  }

  /// 获取认证页面内容
  Future<String> _getAuthServerHtml() async {
    final response = await dio.get(
      _loginUrl,
      options: Options(headers: Map.from(_neededHeaders)..remove('Referer')),
    );
    return response.data;
  }

  /// 判断是否需要验证码
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

  /// 获取验证码
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

  /// 登录统一认证平台
  Future<Response> _postLoginRequest(String username, String hashedPassword, String captcha, String casTicket) async {
    // 登录系统
    final res = await dio.post(_loginUrl,
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
        ));
    // 处理重定向
    return await processRedirect(dio, res, headers: _neededHeaders);
  }

  Future<Response> request(
    String url, {
    Map<String, String>? para,
    data,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    Response response = await _dioRequest(
      url,
      queryParameters: para,
      data: data,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }
}

String hashPassword(String salt, String password) {
  var iv = rds(16);
  var encrypt = SsoEncryption(salt, iv);
  return encrypt.aesEncrypt(rds(64) + password);
}

String rds(int num) {
  var chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678';
  return List.generate(
    num,
    (index) => chars[Random.secure().nextInt(chars.length)],
  ).join();
}

class SsoEncryption {
  Key? _key;
  IV? _iv;

  SsoEncryption(String key, String iv) {
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
