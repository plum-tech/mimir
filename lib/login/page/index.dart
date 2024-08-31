import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/entity/login_status.dart';
import 'package:mimir/credentials/entity/user_type.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/credentials/utils.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/init.dart';
import 'package:mimir/login/utils.dart';
import 'package:mimir/r.dart';
import 'package:mimir/school/widgets/campus.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/settings/dev.dart';
import 'package:mimir/settings/meta.dart';
import 'package:mimir/settings/settings.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart' hide isCupertino;

import '../i18n.dart';
import '../widgets/forgot_pwd.dart';
import '../x.dart';

const i18n = OaLoginI18n();

const oaForgotLoginPasswordUrl =
    "https://authserver.sit.edu.cn/authserver/getBackPasswordMainPage.do?service=https%3A%2F%2Fmyportal.sit.edu.cn%3A443%2F";

class LoginPage extends ConsumerStatefulWidget {
  final bool isGuarded;

  const LoginPage({super.key, required this.isGuarded});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final $account = TextEditingController(text: Dev.demoMode ? R.demoModeOaCredentials.account : null);
  final $password = TextEditingController(text: Dev.demoMode ? R.demoModeOaCredentials.password : null);
  final _formKey = GlobalKey<FormState>();
  bool isPasswordClear = false;
  bool isLoggingIn = false;

  @override
  void initState() {
    super.initState();
    $account.addListener(onAccountChange);
  }

  @override
  void dispose() {
    $account.dispose();
    $password.dispose();
    $account.removeListener(onAccountChange);
    super.dispose();
  }

  void onAccountChange() {
    final old = $account.text;
    final uppercase = old.toUpperCase();
    if (old != uppercase) {
      $account.text = uppercase;
    }
  }

  /// 用户点击登录按钮后
  Future<void> login() async {
    final account = $account.text;
    final password = $password.text;
    if (account == R.demoModeOaCredentials.account && password == R.demoModeOaCredentials.password) {
      await loginDemoMode();
    } else {
      await loginWithCredentials(account, password, formatValid: (_formKey.currentState as FormState).validate());
    }
  }

  Future<void> loginDemoMode() async {
    if (!mounted) return;
    setState(() => isLoggingIn = true);
    final rand = Random();
    await Future.delayed(Duration(milliseconds: rand.nextInt(2000)));
    Meta.userRealName = "Liplum";
    Settings.lastSignature ??= "Liplum";
    CredentialsInit.storage.oaCredentials = R.demoModeOaCredentials;
    CredentialsInit.storage.oaLoginStatus = LoginStatus.validated;
    CredentialsInit.storage.oaLastAuthTime = DateTime.now();
    CredentialsInit.storage.oaUserType = OaUserType.undergraduate;
    Dev.demoMode = true;
    await Init.initModules();
    if (!mounted) return;
    setState(() => isLoggingIn = false);
    context.go("/");
  }

  /// After the user clicks the login button
  Future<void> loginWithCredentials(
    String account,
    String password, {
    required bool formatValid,
  }) async {
    final userType = estimateOaUserType(account);
    if (!formatValid || userType == null || account.isEmpty || password.isEmpty) {
      await context.showTip(
        title: i18n.formatError,
        desc: i18n.validateInputAccountPwdRequest,
        primary: i18n.close,
        serious: true,
      );
      return;
    }

    if (!mounted) return;
    setState(() => isLoggingIn = true);
    final connectionType = await Connectivity().checkConnectivity();
    if (connectionType.contains(ConnectivityResult.none)) {
      if (!mounted) return;
      setState(() => isLoggingIn = false);
      await context.showTip(
        title: i18n.network.error,
        desc: i18n.network.noAccessTip,
        primary: i18n.close,
        serious: true,
      );
      return;
    }

    try {
      await XLogin.login(Credentials(account: account, password: password));
      if (!mounted) return;
      setState(() => isLoggingIn = false);
      context.go("/");
    } catch (error, stackTrace) {
      if (!mounted) return;
      setState(() => isLoggingIn = false);
      if (error is Exception) {
        await handleLoginException(context: context, error: error, stackTrace: stackTrace);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(CredentialsInit.storage.$oaCredentials, (pre, next) {
      if (next != null) {
        $account.text = next.account;
        $password.text = next.password;
      }
    });

    return GestureDetector(
      onTap: () {
        // dismiss the keyboard when tap out of TextField.
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: widget.isGuarded ? i18n.loginRequired.text() : const CampusSelector(),
          actions: [
            PlatformIconButton(
              icon: isCupertino ? const Icon(CupertinoIcons.settings) : const Icon(Icons.settings),
              onPressed: () {
                context.push("/settings");
              },
            ),
          ],
          bottom: isLoggingIn
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(4),
                  child: LinearProgressIndicator(),
                )
              : null,
        ),
        body: buildBody(),
        //to avoid overflow when keyboard is up.
        bottomNavigationBar: const ForgotPasswordButton(url: oaForgotLoginPasswordUrl),
      ),
    );
  }

  Widget buildBody() {
    return [
      widget.isGuarded
          ? const Icon(
              Icons.person_off_outlined,
              size: 120,
            )
          : i18n.welcomeHeader.text(
              style: context.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
      const Padding(padding: EdgeInsets.only(top: 40)),
      // Form field: username and password.
      buildLoginForm(),
      const SizedBox(height: 10),
      buildLoginButton(),
    ].column(mas: MainAxisSize.min).scrolled(physics: const NeverScrollableScrollPhysics()).padH(25).center();
  }

  Widget buildLoginForm() {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          children: [
            TextFormField(
              controller: $account,
              autofillHints: const [AutofillHints.username],
              textInputAction: TextInputAction.next,
              autocorrect: false,
              autofocus: true,
              readOnly: isLoggingIn,
              enableSuggestions: false,
              validator: (account) => studentIdValidator(account, () => i18n.invalidAccountFormat),
              decoration: InputDecoration(
                labelText: i18n.credentials.account,
                hintText: i18n.accountHint,
                icon: Icon(context.icons.person),
              ),
            ),
            TextFormField(
              controller: $password,
              keyboardType: isPasswordClear ? TextInputType.visiblePassword : null,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.send,
              readOnly: isLoggingIn,
              contextMenuBuilder: (ctx, state) {
                return AdaptiveTextSelectionToolbar.editableText(
                  editableTextState: state,
                );
              },
              autocorrect: false,
              autofocus: true,
              enableSuggestions: false,
              obscureText: !isPasswordClear,
              onFieldSubmitted: (inputted) async {
                await login();
              },
              decoration: InputDecoration(
                labelText: i18n.credentials.oaPwd,
                hintText: i18n.oaPwdHint,
                icon: Icon(context.icons.lock),
                suffixIcon: PlatformIconButton(
                  icon: Icon(isPasswordClear ? context.icons.eyeSolid : context.icons.eyeSlashSolid),
                  onPressed: () {
                    setState(() {
                      isPasswordClear = !isPasswordClear;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLoginButton() {
    return [
      $account >>
          (ctx, account) => FilledButton.icon(
                // Online
                onPressed: !isLoggingIn && account.text.isNotEmpty
                    ? () {
                        // un-focus the text field.
                        FocusScope.of(context).requestFocus(FocusNode());
                        login();
                      }
                    : null,
                icon: const Icon(Icons.login),
                label: i18n.login.text(),
              ),
      if (!widget.isGuarded)
        $account >>
            (ctx, account) =>
                $password >>
                (ctx, password) => OutlinedButton(
                      // Offline
                      onPressed: account.text.isNotEmpty || password.text.isNotEmpty
                          ? null
                          : () {
                              CredentialsInit.storage.oaLoginStatus = LoginStatus.offline;
                              context.go("/");
                            },
                      child: i18n.offlineModeBtn.text(),
                    ),
    ].row(caa: CrossAxisAlignment.center, maa: MainAxisAlignment.spaceAround);
  }
}

/// Only allow student ID/ work number.
String? studentIdValidator(String? account, String Function() invalidMessage) {
  if (account != null && account.isNotEmpty) {
    if (estimateOaUserType(account) == null) {
      return invalidMessage();
    }
  }
  return null;
}
