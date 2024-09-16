import 'package:flutter/material.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/login/utils.dart';
import 'package:rettulf/rettulf.dart';

import "../i18n.dart";

enum _State {
  notStart,
  loggingIn,
  success,
}

class LoginTestTile extends StatefulWidget {
  final Credentials credentials;
  final Future<void> Function() login;

  const LoginTestTile({
    super.key,
    required this.credentials,
    required this.login,
  });

  @override
  State<LoginTestTile> createState() => _LoginTestTileState();
}

class _LoginTestTileState extends State<LoginTestTile> {
  var loggingState = _State.notStart;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: loggingState != _State.loggingIn,
      title: i18n.loginTest.text(),
      subtitle: i18n.loginTestDesc.text(),
      leading: const Icon(Icons.login),
      trailing: Padding(
        padding: const EdgeInsets.all(8),
        child: switch (loggingState) {
          _State.loggingIn => const CircularProgressIndicator.adaptive(),
          _State.success => Icon(context.icons.checkMark, color: Colors.green),
          _ => null,
        },
      ),
      onTap: loggingState == _State.loggingIn
          ? null
          : () async {
              setState(() => loggingState = _State.loggingIn);
              try {
                await widget.login();
                if (!mounted) return;
                setState(() => loggingState = _State.success);
              } on Exception catch (error, stackTrace) {
                setState(() => loggingState = _State.notStart);
                if (!context.mounted) return;
                await handleLoginException(context: context, error: error, stackTrace: stackTrace);
              }
            },
    );
  }
}
