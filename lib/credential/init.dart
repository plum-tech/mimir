import 'package:hive/hive.dart';
import 'package:mimir/credential/entity/credential.dart';
import 'package:mimir/design/adaptive/editor.dart';

import 'entity/login_status.dart';
import 'storage/credential.dart';
import 'widgets/editor.dart';

class CredentialInit {
  static late CredentialStorage storage;

  static void init({
    required Box<dynamic> box,
  }) {
    storage = CredentialStorage(box);
    Editor.registerEditor<OaCredentials>((ctx, desc, initial) => CredentialEditor(
          account: initial.account,
          password: initial.password,
          title: desc,
          ctor: (account, password) => OaCredentials(account: account, password: password),
        ));
    EditorEx.registerEnumEditor(LoginStatus.values);
  }
}
