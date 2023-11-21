import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/entity/email.dart';
import 'package:sit/credentials/entity/user_type.dart';
import 'package:sit/design/adaptive/editor.dart';

import 'entity/login_status.dart';
import 'storage/credential.dart';

class CredentialInit {
  static late CredentialStorage storage;

  static void init() {
    storage = const CredentialStorage();
    Editor.registerEditor<OaCredentials>((ctx, desc, initial) => StringsEditor(
          fields: [
            (name: "account", initial: initial.account),
            (name: "password", initial: initial.password),
          ],
          title: desc,
          ctor: (values) => OaCredentials(account: values[0], password: values[1]),
        ));
    Editor.registerEditor<EmailCredentials>((ctx, desc, initial) => StringsEditor(
          fields: [
            (name: "address", initial: initial.address),
            (name: "password", initial: initial.password),
          ],
          title: desc,
          ctor: (values) => EmailCredentials(address: values[0], password: values[1]),
        ));
    EditorEx.registerEnumEditor(LoginStatus.values);
    EditorEx.registerEnumEditor(OaUserType.values);
  }
}
