import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/cupertino.dart';
import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/sso.dart';

class AuthServerService {
  SsoSession get session => Init.ssoSession;

  const AuthServerService();

  Future<String?> getPersonName() async {
    try {
      final response = await session.request('https://authserver.sit.edu.cn/authserver/index.do', ReqMethod.get);
      final html = BeautifulSoup(response.data);
      final resultDesktop = html.find('div', class_: 'auth_username')?.text ?? '';
      final resultMobile = html.find('div', class_: 'index-nav-name')?.text ?? '';

      final result = (resultMobile + resultDesktop).trim();
      return result.isNotEmpty ? result : null;
    } catch (error, stackTrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }
}
