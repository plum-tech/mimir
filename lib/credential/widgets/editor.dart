import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../using.dart';

typedef CredentialCtor<T> = T Function(String account, String password);

const _i18n = CredentialI18n();

class CredentialEditor<T> extends StatefulWidget {
  final String account;
  final String password;
  final String? title;
  final CredentialCtor<T> ctor;

  const CredentialEditor({
    super.key,
    required this.account,
    required this.password,
    required this.title,
    required this.ctor,
  });

  @override
  State<CredentialEditor> createState() => _CredentialEditorState();
}

class _CredentialEditorState extends State<CredentialEditor> {
  late TextEditingController $account;
  late TextEditingController $password;

  @override
  void initState() {
    super.initState();
    $account = TextEditingController(text: widget.account);
    $password = TextEditingController(text: widget.password);
  }

  @override
  void dispose() {
    super.dispose();
    $account.dispose();
    $password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return $Dialog$(
      title: widget.title,
      make: (ctx) => [
        buildField("account", $account),
        buildField("password", $password),
      ].column(mas: MainAxisSize.min),
      primary: $Action$(
          text: _i18n.submit,
          onPressed: () {
            context.navigator.pop(widget.ctor($account.text, $password.text));
          }),
      secondary: $Action$(
          text: _i18n.cancel,
          onPressed: () {
            context.navigator.pop(widget.ctor(widget.account, widget.password));
          }),
    );
  }

  Widget buildField(
    String fieldName,
    TextEditingController textEditingController,
  ) {
    return $TextField$(
      controller: textEditingController,
      textInputAction: TextInputAction.next,
      labelText: fieldName,
    ).padV(1);
  }
}
