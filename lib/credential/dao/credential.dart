import '../entity/credential.dart';

abstract class CredentialDao {
  OACredential? oaCredential;
  DateTime? get lastOaAuthTime;
}
