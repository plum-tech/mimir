import 'package:mimir/app.dart';
import 'package:mimir/credential/dao/credential.dart';
import 'package:mimir/credential/storage/credential.dart';
import 'package:mimir/events/bus.dart';
import 'package:mimir/events/events.dart';

import 'entity/credential.dart';
import 'widgets/scope.dart';

class CredentialDelegate implements CredentialDao {
  final CredentialStorage storage;

  CredentialDelegate(this.storage);

  /// [storage.oaCredential] does also work. But I prefer to use Inherited Widget.
  @override
  OACredential? get oaCredential => $Key.currentContext!.auth.oaCredential;

  @override
  set oaCredential(OACredential? newV) {
    if (storage.oaCredential != newV) {
      storage.oaCredential = newV;
      if (newV != null) {
        storage.lastOaAuthTime = DateTime.now();
      }
      FireOn.global(CredentialChangeEvent());
    }
  }

  @override
  DateTime? get lastOaAuthTime => $Key.currentContext!.auth.lastOaAuthTime;

  set lastOaAuthTime(DateTime? newV) {
    storage.lastOaAuthTime = newV;
  }
}
