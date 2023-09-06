import 'package:hive/hive.dart';
import 'package:mimir/credential/entity/credential.dart';
import 'package:mimir/design/widgets/editor.dart';

import 'entity/login_status.dart';
import 'storage/credential.dart';
import 'widgets/editor.dart';

class CredentialInit {
  static late CredentialStorage storage;

  static void init({
    required Box<dynamic> box,
  }) {
    storage = CredentialStorage(box);
    Editor.registerEditor<OaCredential>((ctx, desc, initial) => CredentialEditor(
          account: initial.account,
          password: initial.password,
          title: desc,
          ctor: (account, password) => OaCredential(account: account, password: password),
        ));
    EditorEx.registerEnumEditor(LoginStatus.values);
  }
}
