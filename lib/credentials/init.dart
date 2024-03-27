import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/entity/user_type.dart';
import 'package:sit/design/adaptive/editor.dart';

import 'entity/login_status.dart';
import 'storage/credential.dart';

class CredentialsInit {
  static late CredentialStorage storage;

  static void init() {
    storage = CredentialStorage();
    Editor.registerEditor<Credentials>((ctx, desc, initial) => StringsEditor(
          fields: [
            (name: "account", initial: initial.account),
            (name: "password", initial: initial.password),
          ],
          title: desc,
          ctor: (values) => Credentials(account: values[0], password: values[1]),
        ));
    EditorEx.registerEnumEditor(LoginStatus.values);
    EditorEx.registerEnumEditor(OaUserType.values);
  }
}
