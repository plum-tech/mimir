import 'dart:math';

import 'package:encrypt/encrypt.dart';

String hashPassword(String salt, String password) {
  var iv = rds(16);
  var encrypt = MyEncrypt(salt, iv);
  return encrypt.aesEncrypt(rds(64) + password);
}

String rds(int num) {
  var chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678';
  return List.generate(
    num,
    (index) => chars[Random.secure().nextInt(chars.length)],
  ).join();
}

class MyEncrypt {
  Key? _key;
  IV? _iv;

  MyEncrypt(String key, String iv) {
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
