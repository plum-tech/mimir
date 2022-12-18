import '../entity/credential.dart';
import '../entity/user_type.dart';

abstract class CredentialDao {
  OACredential? oaCredential;
  DateTime? get lastOaAuthTime;
}
