abstract class AdminSettingDao {
  /// 获取当前问答模块的密钥
  String? get bbsSecret;

  /// 设置一个null表示退出模块管理模式
  set bbsSecret(String? foo);
}
