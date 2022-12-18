import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mimir/exception/session.dart';
import 'package:mimir/module/activity/using.dart';
import 'package:mimir/module/login/init.dart';
import 'package:rettulf/rettulf.dart';

import '../symbol.dart';
import '../using.dart';

class UnauthorizedTipPage extends StatefulWidget {
  final Widget? title;
  final VoidCallback? onLogin;

  const UnauthorizedTipPage({super.key, this.title, this.onLogin});

  @override
  State<UnauthorizedTipPage> createState() => _UnauthorizedTipPageState();
}

class _UnauthorizedTipPageState extends State<UnauthorizedTipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title ?? i18n.unauthorizedTipTitle.text(),
      ),
      body: UnauthorizedTip(onLogin: widget.onLogin),
    );
  }
}

class UnauthorizedTip extends StatefulWidget {
  final VoidCallback? onLogin;

  const UnauthorizedTip({super.key, this.onLogin});

  @override
  State<UnauthorizedTip> createState() => _UnauthorizedTipState();
}

class _UnauthorizedTipState extends State<UnauthorizedTip> {
  final $account = TextEditingController();
  final $password = TextEditingController();
  bool isPasswordClear = false;
  bool enableLoginButton = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return buildBody(context).padAll(20);
  }

  Widget buildBody(BuildContext ctx) {
    return ctx.isPortrait ? buildBodyPortrait(ctx) : buildBodyLandscape(ctx);
  }

  Widget buildBodyPortrait(BuildContext ctx) {
    final full = ctx.mediaQuery.size;
    return LayoutBuilder(builder: (ctx, box) {
      if (box.maxHeight < full.height / 5 * 4) {
        return [
          buildTip(ctx).flexible(flex: 1),
          [
            buildLoginArea(ctx),
            buildLoginButton(ctx).padAll(20),
          ].column().padAll(20).flexible(flex: 3),
        ].column(maa: MAAlign.spaceEvenly);
      } else {
        return [
          buildIcon(ctx).flexible(flex: 1),
          buildTip(ctx).flexible(flex: 1),
          [
            buildLoginArea(ctx),
            buildLoginButton(ctx).padAll(20),
          ].column().padAll(20).flexible(flex: 3),
        ].column(maa: MAAlign.spaceEvenly);
      }
    });
  }

  Widget buildBodyLandscape(BuildContext ctx) {
    return [
      [
        buildIcon(ctx),
        buildTip(ctx),
      ].column().flexible(flex: 2),
      [
        buildLoginArea(ctx),
        buildLoginButton(ctx).padAll(20),
      ].column().padAll(20).flexible(flex: 3),
    ].row(maa: MAAlign.spaceEvenly).scrolled().center();
  }

  Widget buildIcon(BuildContext ctx) {
    return Icon(
      Icons.person_off_outlined,
      color: ctx.darkSafeThemeColor,
      size: 120,
    ).padV(20);
  }

  String get tip {
    if (Auth.hasLoggedIn) {
      return i18n.unauthorizedTipEverLoggedInTip;
    } else {
      return i18n.unauthorizedTipNeverLoggedInTip;
    }
  }

  Widget buildTip(BuildContext ctx) {
    return tip.text(style: context.textTheme.titleLarge, textAlign: TextAlign.center).center().padAll(10);
  }

  Widget buildLoginArea(BuildContext ctx) {
    return Form(
        autovalidateMode: AutovalidateMode.always,
        key: _formKey,
        child: [
          TextFormField(
            controller: $account,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            enableSuggestions: false,
            validator: studentIdValidator,
            decoration: InputDecoration(
                labelText: i18n.account, hintText: i18n.loginLoginAccountHint, icon: const Icon(Icons.person)),
          ),
          TextFormField(
            controller: $password,
            textInputAction: TextInputAction.send,
            toolbarOptions: const ToolbarOptions(
              copy: false,
              cut: false,
              paste: false,
              selectAll: false,
            ),
            autocorrect: false,
            enableSuggestions: false,
            obscureText: !isPasswordClear,
            onFieldSubmitted: (inputted) {
              if (enableLoginButton) {
                onLogin(ctx);
              }
            },
            decoration: InputDecoration(
              labelText: i18n.oaPwd,
              hintText: i18n.loginPwdHint,
              icon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                // 切换密码明文显示状态的图标按钮
                icon: Icon(isPasswordClear ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    isPasswordClear = !isPasswordClear;
                  });
                },
              ),
            ),
          )
        ].column());
  }

  String get buttonText {
    if (Auth.hasLoggedIn) {
      return i18n.relogin;
    } else {
      return i18n.loginLoginBtn;
    }
  }

  Widget buildLoginButton(BuildContext ctx) {
    const textStyle = TextStyle(fontSize: 18);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          // Online
          onPressed: enableLoginButton
              ? () {
                  // un-focus the text field.
                  FocusScope.of(context).requestFocus(FocusNode());
                  onLogin(ctx);
                }
              : null,
          child: buttonText.text(style: textStyle).padAll(10),
        ),
      ],
    );
  }

  Future<void> onLogin(BuildContext ctx) async {
    bool formValid = (_formKey.currentState as FormState).validate();
    final account = $account.text;
    final password = $password.text;
    if (!formValid || account.isEmpty || password.isEmpty) {
      await ctx.showTip(
        title: i18n.formatError,
        desc: i18n.validateInputAccountPwdRequest,
        ok: i18n.close,
        serious: true,
      );
      return;
    }
    if (!mounted) return;
    setState(() => enableLoginButton = false);

    final connectionType = await Connectivity().checkConnectivity();
    if (connectionType == ConnectivityResult.none) {
      if (!mounted) return;
      setState(() => enableLoginButton = true);
      if (mounted) {
        await ctx.showTip(
          title: i18n.networkError,
          desc: i18n.networkNoAccessTip,
          ok: i18n.close,
          serious: true,
        );
      }
      return;
    }

    try {
      final credential = OACredential(account, password);
      await LoginInit.ssoSession.loginActive(credential);
      final personName = await LoginInit.authServerService.getPersonName();
      Auth.oaCredential = credential;
      Kv.auth.personName = personName;
      // Reset the home
      Kv.home.homeItems = null;
      if (!mounted) return;
      widget.onLogin?.call();
    } on CredentialsInvalidException catch (e) {
      if (!mounted) return;
      await ctx.showTip(
        title: i18n.loginFailedWarn,
        desc: e.msg,
        ok: i18n.close,
      );
      return;
    } catch (e) {
      if (!mounted) return;
      await ctx.showTip(
        title: i18n.loginFailedWarn,
        desc: i18n.accountOrPwdIncorrectTip,
        ok: i18n.close,
        serious: true,
      );
    } finally {
      if (mounted) {
        setState(() => enableLoginButton = true);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    $account.dispose();
    $password.dispose();
  }
}
