import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/editor.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/init.dart';
import 'package:mimir/login/utils.dart';
import '../i18n.dart';

const _changePasswordUrl = "https://authserver.sit.edu.cn/authserver/passwordChange.do";

class CredentialsPage extends ConsumerStatefulWidget {
  const CredentialsPage({super.key});

  @override
  ConsumerState<CredentialsPage> createState() => _CredentialsPageState();
}

class _CredentialsPageState extends ConsumerState<CredentialsPage> {
  var showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar.large(
            pinned: true,
            snap: false,
            floating: false,
            title: i18n.oaCredentials.oaAccount.text(),
          ),
          buildBody(),
        ],
      ),
    );
  }

  Widget buildBody() {
    final credentials = ref.watch(CredentialsInit.storage.oa.$credentials);
    final all = <WidgetBuilder>[];
    if (credentials != null) {
      all.add((_) => buildAccount(credentials));
      all.add((_) => const Divider());
      all.add((_) => buildPassword(credentials));
      all.add((_) => TestLoginTile(credentials: credentials));
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: all.length,
        (ctx, index) {
          return all[index](ctx);
        },
      ),
    );
  }

  Widget buildAccount(Credentials credential) {
    return ListTile(
      title: i18n.oaCredentials.oaAccount.text(),
      subtitle: credential.account.text(),
      leading: Icon(context.icons.person),
      trailing: Icon(context.icons.copy),
      onTap: () async {
        context.showSnackBar(content: i18n.copyTipOf(i18n.oaCredentials.oaAccount).text());
        // Copy the student ID to clipboard
        await Clipboard.setData(ClipboardData(text: credential.account));
      },
    );
  }

  Widget buildPassword(Credentials credential) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 100),
      child: ListTile(
        title: i18n.oaCredentials.savedOaPwd.text(),
        subtitle: Text(!showPassword ? i18n.oaCredentials.savedOaPwdDesc : credential.password),
        leading: const Icon(Icons.password_rounded),
        trailing: [
          PlatformIconButton(
            icon: Icon(context.icons.edit),
            onPressed: () async {
              final newPwd = await Editor.showStringEditor(
                context,
                desc: i18n.oaCredentials.savedOaPwd,
                initial: credential.password,
              );
              if (newPwd != credential.password) {
                if (!mounted) return;
                CredentialsInit.storage.oa.credentials = credential.copyWith(password: newPwd);
                setState(() {});
              }
            },
          ),
          PlatformIconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: showPassword ? const Icon(Icons.visibility) : const Icon(Icons.visibility_off)),
        ].wrap(),
      ),
    );
  }
}

enum _TestLoginState {
  notStart,
  loggingIn,
  success,
}

class TestLoginTile extends StatefulWidget {
  final Credentials credentials;

  const TestLoginTile({
    super.key,
    required this.credentials,
  });

  @override
  State<TestLoginTile> createState() => _TestLoginTileState();
}

class _TestLoginTileState extends State<TestLoginTile> {
  var loggingState = _TestLoginState.notStart;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      enabled: loggingState != _TestLoginState.loggingIn,
      title: i18n.oaCredentials.testLoginOa.text(),
      subtitle: i18n.oaCredentials.testLoginOaDesc.text(),
      leading: const Icon(Icons.login),
      trailing: Padding(
        padding: const EdgeInsets.all(8),
        child: switch (loggingState) {
          _TestLoginState.loggingIn => const CircularProgressIndicator.adaptive(),
          _TestLoginState.success => Icon(context.icons.checkMark, color: Colors.green),
          _ => null,
        },
      ),
      onTap: loggingState == _TestLoginState.loggingIn
          ? null
          : () async {
              setState(() => loggingState = _TestLoginState.loggingIn);
              try {
                await Init.ssoSession.deleteSitUriCookies();
                await Init.ssoSession.loginLocked(widget.credentials);
                if (!mounted) return;
                setState(() => loggingState = _TestLoginState.success);
              } on Exception catch (error, stackTrace) {
                setState(() => loggingState = _TestLoginState.notStart);
                if (!context.mounted) return;
                await handleLoginException(context: context, error: error, stackTrace: stackTrace);
              }
            },
    );
  }
}
