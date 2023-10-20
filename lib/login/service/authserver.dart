import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:sit/init.dart';
import 'package:sit/network/session.dart';
import 'package:sit/session/sso.dart';

class AuthServerService {
  SsoSession get session => Init.ssoSession;

  const AuthServerService();

  Future<String?> getPersonName() async {
    final response = await session.request('https://authserver.sit.edu.cn/authserver/index.do', ReqMethod.get);
    final resultDesktop = BeautifulSoup(response.data).find('div', class_: 'auth_username')?.text ?? '';
    final resultMobile = BeautifulSoup(response.data).find('div', class_: 'index-nav-name')?.text ?? '';

    final result = resultMobile + resultDesktop;
    if (result.isNotEmpty) return result.trim();
    return null;
  }
}
