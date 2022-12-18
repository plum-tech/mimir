/// 本地jwt缓存接口
abstract class JwtDao {
  set jwtToken(String? foo);

  String? get jwtToken;
}
