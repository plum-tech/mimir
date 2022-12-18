import 'package:hive/hive.dart';

import '../dao/jwt.dart';

class JwtKeys {
  static const namespace = '/kite';
  static const jwt = '$namespace/jwt';
}

class JwtStorage implements JwtDao {
  final Box<dynamic> box;

  JwtStorage(this.box);

  @override
  String? get jwtToken => box.get(JwtKeys.jwt, defaultValue: null);

  @override
  set jwtToken(String? jwt) => box.put(JwtKeys.jwt, jwt);
}
