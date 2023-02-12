import 'package:mimir/credential/entity/credential.dart';
import 'package:mimir/design/widgets/editor.dart';
import 'package:mimir/hive/using.dart';

import 'entity/user_type.dart';
import 'storage/credential.dart';
import 'widgets/editor.dart';
import 'using.dart';

class CredentialInit {
  static late CredentialStorage credential;

  static void init({
    required Box<dynamic> box,
  }) {
    credential = CredentialStorage(box);
    Editor.registerEditor<OACredential>((ctx, desc, initial) => CredentialEditor(
          account: initial.account,
          password: initial.password,
          title: desc,
          ctor: (account, password) => OACredential(account, password),
        ));
    EditorEx.registerEnumEditor(UserType.values);
  }
}
