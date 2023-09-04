import 'package:mimir/credential/entity/credential.dart';
import 'package:mimir/design/widgets/editor.dart';
import 'package:mimir/hive/using.dart';

import 'entity/login_status.dart';
import 'storage/credential.dart';
import 'widgets/editor.dart';
import 'using.dart';

class CredentialInit {
  static late CredentialStorage storage;

  static void init({
    required Box<dynamic> box,
  }) {
    storage = CredentialStorage(box);
    Editor.registerEditor<Credential>((ctx, desc, initial) => CredentialEditor(
          account: initial.account,
          password: initial.password,
          title: desc,
          ctor: (account, password) => Credential(account, password),
        ));
    EditorEx.registerEnumEditor(LoginStatus.values);
  }
}
