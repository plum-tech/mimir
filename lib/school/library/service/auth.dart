import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/pointycastle.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/error.dart';
import 'package:mimir/init.dart';
import 'package:mimir/utils/dio.dart';

const _opacUrl = 'http://210.35.66.106/opac';
const _pemUrl = '$_opacUrl/certificate/pem';
const _loginUrl = '$_opacUrl/reader/doLogin';

class LibraryAuthService {
  Dio get dio => Init.schoolDio;

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
    final pk = await _getRSAPublicKey();
    final rdPasswd = _encryptPasswordWithRSA(password, publicKey: pk as RSAPublicKey);
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
    return dio.processRedirect(response);
  }

  Future<RSAAsymmetricKey> _getRSAPublicKey() async {
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

  String _encryptPasswordWithRSA(
    String password, {
    required RSAPublicKey publicKey,
  }) {
    String hashedPwd = md5.convert(const Utf8Encoder().convert(password)).toString();
    final encrypter = Encrypter(RSA(publicKey: publicKey));
    final String encryptedPwd = encrypter.encrypt(hashedPwd).base64;
    return encryptedPwd;
  }
}
