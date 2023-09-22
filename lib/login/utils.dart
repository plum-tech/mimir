/// 代理配置的正则匹配式. 格式为 (域名|IP):端口
/// 注意此处端口没有限制为 0-65535.
final RegExp reProxyString = RegExp(
    r'(([a-zA-Z0-9][-a-zA-Z0-9]{0,62}(.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+.?)|(((25[0-5])|(2[0-4]d)|(1dd)|([1-9]d)|d)(.((25[0-5])|(2[0-4]d)|(1dd)|([1-9]d)|d)){3})):\d{1,5}');

String? proxyValidator(String? proxy) {
  if (proxy != null && proxy.isNotEmpty) {
    if (!reProxyString.hasMatch(proxy)) {
      return '代理地址格式不正确';
    }
  }
  return null;
}
