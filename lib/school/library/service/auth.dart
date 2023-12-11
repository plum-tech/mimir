import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/error.dart';
import 'package:sit/init.dart';
import 'package:sit/utils/dio.dart';

const _opacUrl = 'http://210.35.66.106/opac';
const _pemUrl = '$_opacUrl/certificate/pem';
const _loginUrl = '$_opacUrl/reader/doLogin';

class LibraryAuthService {
  Dio get dio => Init.dio;

  const LibraryAuthService();

  Future<Response> login(Credentials credentials) async {
    final response = await _login(credentials.account, credentials.password);
    final content = response.data.toString();
    if (content.contains('用户名或密码错误')) {
      throw CredentialsException(
        type: CredentialsErrorType.accountPassword,
        message: content,
      );
    }
    // TODO: Handle other exceptions
    return response;
  }

  Future<Response> _login(String username, String password) async {
    final rdPasswd = await _encryptPassword(password);
    final response = await dio.post(
      _loginUrl,
      data: {
        'vToken': '',
        'rdLoginId': username,
        'p': '',
        'rdPasswd': rdPasswd,
        'returnUrl': '',
        'password': '',
      },
      options: disableRedirectFormEncodedOptions(),
    );
    return processRedirect(dio, response);
  }

  Future<String> _encryptPassword(String password) async {
    String hashedPwd = md5.convert(const Utf8Encoder().convert(password)).toString();
    final pk = await _getRSAPublicKey();
    final encrypter = Encrypter(RSA(publicKey: pk));
    final String encryptedPwd = encrypter.encrypt(hashedPwd).base64;
    return encryptedPwd;
  }

  Future<dynamic> _getRSAPublicKey() async {
    final pemResponse = await dio.get(
      _pemUrl,
      queryParameters: {
        "checkCode": "1opac",
      },
    );
    String publicKeyStr = pemResponse.data;
    final pemFileContent = '-----BEGIN PUBLIC KEY-----\n$publicKeyStr\n-----END PUBLIC KEY-----';

    final parser = RSAKeyParser();
    return parser.parse(pemFileContent);
  }
}
