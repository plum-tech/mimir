import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/entity/login_status.dart';
import 'package:sit/credentials/entity/user_type.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/credentials/utils.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/init.dart';
import 'package:sit/login/utils.dart';
import 'package:sit/r.dart';
import 'package:sit/school/widgets/campus.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/settings/dev.dart';
import 'package:sit/settings/settings.dart';

import '../aggregated.dart';
import '../i18n.dart';
import '../widgets/forgot_pwd.dart';

const i18n = OaLoginI18n();

const _forgotLoginPasswordUrl =
    "https://authserver.sit.edu.cn/authserver/getBackPasswordMainPage.do?service=https%3A%2F%2Fmyportal.sit.edu.cn%3A443%2F";

class LoginPage extends StatefulWidget {
  final bool isGuarded;

  const LoginPage({super.key, required this.isGuarded});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final $account = TextEditingController();
  final $password = TextEditingController();
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

  @override
  void didChangeDependencies() {
    final oaCredential = context.auth.credentials;
    if (oaCredential != null) {
      $account.text = oaCredential.account;
      $password.text = oaCredential.password;
    }
    super.didChangeDependencies();
  }

  /// 用户点击登录按钮后
  Future<void> login() async {
    final account = $account.text;
    final password = $password.text;
    if (account == R.demoModeOaAccount && password == R.demoModeOaPassword) {
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
    Settings.lastSignature ??= "Liplum";
    CredentialsInit.storage.oaCredentials = Credentials(account: R.demoModeOaAccount, password: R.demoModeOaPassword);
    CredentialsInit.storage.oaLoginStatus = LoginStatus.validated;
    CredentialsInit.storage.oaLastAuthTime = DateTime.now();
    CredentialsInit.storage.oaUserType = OaUserType.undergraduate;
    Dev.demoMode = true;
    await Init.initModules();
    if (!mounted) return;
    setState(() => isLoggingIn = false);
    context.go("/");
  }

  /// 用户点击登录按钮后
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
        ok: i18n.close,
        serious: true,
      );
      return;
    }

    if (!mounted) return;
    setState(() => isLoggingIn = true);
    final connectionType = await Connectivity().checkConnectivity();
    if (connectionType == ConnectivityResult.none) {
      if (!mounted) return;
      setState(() => isLoggingIn = false);
      await context.showTip(
        title: i18n.network.error,
        desc: i18n.network.noAccessTip,
        ok: i18n.close,
        serious: true,
      );
      return;
    }

    try {
      await LoginAggregated.login(Credentials(account: account, password: password));
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
    return GestureDetector(
      onTap: () {
        // dismiss the keyboard when tap out of TextField.
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: widget.isGuarded ? i18n.loginRequired.text() : const CampusSelector(),
          actions: [
            IconButton(
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
        bottomNavigationBar: const ForgotPasswordButton(url: _forgotLoginPasswordUrl),
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
      Padding(padding: EdgeInsets.only(top: 40.h)),
      // Form field: username and password.
      buildLoginForm(),
      SizedBox(height: 10.h),
      buildLoginButton(),
    ].column(mas: MainAxisSize.min).scrolled(physics: const NeverScrollableScrollPhysics()).padH(25.h).center();
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
                icon: const Icon(Icons.person),
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
                icon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(isPasswordClear ? Icons.visibility : Icons.visibility_off),
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
        OutlinedButton(
          // Offline
          onPressed: () {
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
