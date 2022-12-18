import 'dao/credential.dart';
import 'entity/user_type.dart';

extension CredentialEx on CredentialDao {
  bool get hasLoggedIn => lastOaAuthTime != null;
}
