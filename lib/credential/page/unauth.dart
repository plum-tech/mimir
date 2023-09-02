import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/exception/session.dart';
import 'package:mimir/mini_apps/login/init.dart';
import 'package:rettulf/rettulf.dart';

import '../symbol.dart';
import '../using.dart';

const _i18n = CredentialI18n();

class UnauthorizedTipPage extends StatefulWidget {
  const UnauthorizedTipPage({super.key});

  @override
  State<UnauthorizedTipPage> createState() => _UnauthorizedTipPageState();
}

class _UnauthorizedTipPageState extends State<UnauthorizedTipPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _i18n.unauthorizedTip.title.text(),
      ),
      body: UnauthorizedTip(),
    );
  }
}

class UnauthorizedTip extends StatefulWidget {
  const UnauthorizedTip({super.key});

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
    if (context.auth.loginStatus == LoginStatus.never) {
      return _i18n.unauthorizedTip.neverLoggedInTip;
    } else {
      return _i18n.unauthorizedTip.everLoggedInTip;
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
                labelText: _i18n.account, hintText: _i18n.loginLoginAccountHint, icon: const Icon(Icons.person)),
          ),
          TextFormField(
            controller: $password,
            textInputAction: TextInputAction.send,
            //TODO: Flutter 3.7
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
              labelText: _i18n.oaPwd,
              hintText: _i18n.loginPwdHint,
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
    if (context.auth.oaCredential != null) {
      return _i18n.relogin;
    } else {
      return _i18n.loginLoginBtn;
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
        title: _i18n.formatError,
        desc: _i18n.validateInputAccountPwdRequest,
        ok: _i18n.close,
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
          title: _i18n.network.error,
          desc: _i18n.network.noAccessTip,
          ok: _i18n.close,
          serious: true,
        );
      }
      return;
    }

    try {
      final credential = OACredential(account, password);
      await LoginInit.ssoSession.loginActive(credential);
      final personName = await LoginInit.authServerService.getPersonName();
      if (!mounted) return;
      context.auth.setOaCredential(credential);
      // go back to homepage.
      context.push("/");
    } on CredentialsInvalidException catch (e) {
      if (!mounted) return;
      await ctx.showTip(
        title: _i18n.loginFailedWarn,
        desc: e.msg,
        ok: _i18n.close,
      );
      return;
    } catch (e) {
      if (!mounted) return;
      await ctx.showTip(
        title: _i18n.loginFailedWarn,
        desc: _i18n.accountOrPwdIncorrectTip,
        ok: _i18n.close,
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
