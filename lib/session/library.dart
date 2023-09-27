import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:mimir/exception/session.dart';
import 'package:mimir/network/session.dart';
import 'package:mimir/session/common.dart';
import 'package:mimir/utils/dio_utils.dart';

class LibrarySession extends DefaultDioSession {
  static const _opacUrl = 'http://210.35.66.106/opac';
  static const _pemUrl = '$_opacUrl/certificate/pem';
  static const _doLoginUrl = '$_opacUrl/reader/doLogin';

  LibrarySession(Dio dio) : super(dio);

  Future<Response> login(String username, String password) async {
    final response = await _login(username, password);
    final content = response.data.toString();
    if (content.contains('用户名或密码错误')) {
      throw OaCredentialsException(
        type: OaCredentialsErrorType.accountPassword,
        message: content,
      );
    }
    // TODO: 还有其他错误处理
    return response;
  }

  Future<Response> _login(String username, String password) async {
    final response = await dio.post(
      _doLoginUrl,
      data: {
        'vToken': '',
        'rdLoginId': username,
        'p': '',
        'rdPasswd': await _encryptPassword(password),
        'returnUrl': '',
        'password': '',
      },
      options: DioUtils.NON_REDIRECT_OPTION_WITH_FORM_TYPE.copyWith(
        contentType: 'application/x-www-form-urlencoded',
      ),
    );
    return DioUtils.processRedirect(dio, response);
  }

  Future<String> _encryptPassword(String password) async {
    String hashedPwd = md5.convert(const Utf8Encoder().convert(password)).toString();
    final pk = await _getRSAPublicKey();
    final encrypter = Encrypter(RSA(publicKey: pk));
    final String encryptedPwd = encrypter.encrypt(hashedPwd).base64;
    return encryptedPwd;
  }

  Future<dynamic> _getRSAPublicKey() async {
    final pemResponse = await request(_pemUrl, ReqMethod.get);
    String publicKeyStr = pemResponse.data;
    final pemFileContent = '-----BEGIN PUBLIC KEY-----\n$publicKeyStr\n-----END PUBLIC KEY-----';

    final parser = RSAKeyParser();
    return parser.parse(pemFileContent);
  }
}
