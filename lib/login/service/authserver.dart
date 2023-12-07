import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:dio/dio.dart';
import 'package:sit/init.dart';

import 'package:sit/session/sso.dart';
import 'package:sit/utils/error.dart';

class AuthServerService {
  SsoSession get session => Init.ssoSession;

  const AuthServerService();

  Future<String?> getPersonName() async {
    try {
      final response = await session.request(
        'https://authserver.sit.edu.cn/authserver/index.do',
        options: Options(
          method: "GET",
        ),
      );
      final html = BeautifulSoup(response.data);
      final resultDesktop = html.find('div', class_: 'auth_username')?.text ?? '';
      final resultMobile = html.find('div', class_: 'index-nav-name')?.text ?? '';

      final result = (resultMobile + resultDesktop).trim();
      return result.isNotEmpty ? result : null;
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      return null;
    }
  }
}
