import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';

typedef CredentialCtor<T> = T Function(String account, String password);

const _i18n = CredentialsI18n();

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
      make: (ctx) => AutofillGroup(
        child: [
          buildField(
            "account",
            $account,
            textInputAction: TextInputAction.next,
          ).padAll(1),
          buildField(
            "password",
            $password,
            textInputAction: TextInputAction.send,
            onSubmit: (value) {
              context.navigator.pop(widget.ctor($account.text, $password.text));
            },
          ).padAll(1),
        ].column(mas: MainAxisSize.min),
      ),
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
    TextEditingController textEditingController, {
    TextInputAction? textInputAction,
    ValueChanged<String>? onSubmit,
  }) {
    return $TextField$(
      controller: textEditingController,
      textInputAction: textInputAction,
      labelText: fieldName,
      onSubmit: onSubmit,
    );
  }
}
