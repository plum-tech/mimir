abstract class NetworkSettingDao {
  // 代理服务器地址
  String get proxy;

  set proxy(String foo);

  // 是否启用代理
  bool get useProxy;

  set useProxy(bool foo);

  // 全局模式（无视 dio 初始化时的代理规则）
  bool get isGlobalProxy;

  set isGlobalProxy(bool foo);
}
