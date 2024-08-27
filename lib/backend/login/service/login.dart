import 'package:mimir/init.dart';
import 'package:mimir/session/mimir.dart';

class LoginService {
  MimirSession get _session => Init.mimirSession;

  const LoginService();
}
