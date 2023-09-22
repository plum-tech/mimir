import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credential/entity/credential.dart';
import 'package:mimir/credential/entity/email.dart';
import 'package:mimir/credential/entity/login_status.dart';
import 'package:mimir/credential/init.dart';
import 'package:mimir/credential/utils.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/exception/session.dart';
import 'package:mimir/r.dart';
import 'package:mimir/settings/widgets/campus.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:rettulf/rettulf.dart';

import '../init.dart';
import '../i18n.dart';
import '../utils.dart';

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
  }

  @override
  void dispose() {
    $account.dispose();
    $password.dispose();
    super.dispose();
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
  Future<void> onLogin() async {
    bool formValid = (_formKey.currentState as FormState).validate();
    final account = $account.text;
    final password = $password.text;
    if (!formValid || account.isEmpty || password.isEmpty) {
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
      final oaCredential = OaCredentials(account: account, password: password);
      await LoginInit.ssoSession.loginActiveLocked(oaCredential);
      // final personName = await LoginInit.authServerService.getPersonName();
      if (!mounted) return;
      setState(() => isLoggingIn = false);
      CredentialInit.storage.oaCredentials = oaCredential;
      CredentialInit.storage.oaLoginStatus = LoginStatus.validated;
      CredentialInit.storage.oaLastAuthTime = DateTime.now();
      // Edu email has the same credential as OA by default.
      // So assume this can work at first time.
      CredentialInit.storage.eduEmailCredentials ??= EmailCredentials(
        address: R.formatEduEmail(username: oaCredential.account),
        password: oaCredential.password,
      );
      context.go("/");
      setState(() => isLoggingIn = false);
    } on UnknownAuthException catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stacktrace);
      if (!mounted) return;
      setState(() => isLoggingIn = false);
      await context.showTip(
        serious: true,
        title: i18n.failedWarn,
        desc: i18n.unknownAuthErrorTip,
        ok: i18n.close,
      );
    } on OaCredentialsException catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stacktrace);
      if (!mounted) return;
      setState(() => isLoggingIn = false);
      if (e.type == OaCredentialsErrorType.accountPassword) {
        await context.showTip(
          serious: true,
          title: i18n.failedWarn,
          desc: i18n.accountOrPwdErrorTip,
          ok: i18n.close,
        );
      } else if (e.type == OaCredentialsErrorType.captcha) {
        await context.showTip(
          serious: true,
          title: i18n.failedWarn,
          desc: i18n.captchaErrorTip,
          ok: i18n.close,
        );
      } else if (e.type == OaCredentialsErrorType.frozen) {
        await context.showTip(
          serious: true,
          title: i18n.failedWarn,
          desc: i18n.accountFrozenTip,
          ok: i18n.close,
        );
      }
      return;
    } on DioException catch (error, stacktrace) {
      debugPrint(error.toString());
      debugPrintStack(stackTrace: stacktrace);
      if (!mounted) return;
      setState(() => isLoggingIn = false);
      await context.showTip(
        serious: true,
        title: i18n.failedWarn,
        desc: i18n.schoolServerUnconnectedTip,
        ok: i18n.close,
      );
    } on LoginCaptchaCancelledException {
      if (!mounted) return;
      setState(() => isLoggingIn = false);
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
              icon: const Icon(Icons.settings),
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
        bottomNavigationBar: const ForgotPasswordButton(),
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
      child: Column(
        children: [
          TextFormField(
            controller: $account,
            textInputAction: TextInputAction.next,
            autocorrect: false,
            autofocus: true,
            enableSuggestions: false,
            validator: (account) => studentIdValidator(account, () => i18n.invalidAccountFormat),
            decoration: InputDecoration(
              labelText: i18n.credential.account,
              hintText: i18n.accountHint,
              icon: const Icon(Icons.person),
            ),
          ),
          TextFormField(
            controller: $password,
            textInputAction: TextInputAction.send,
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
              if (!isLoggingIn) {
                await onLogin();
              }
            },
            decoration: InputDecoration(
              labelText: i18n.credential.oaPwd,
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
                        onLogin();
                      }
                    : null,
                icon: const Icon(Icons.login),
                label: i18n.loginBtn.text(),
              ),
      if (!widget.isGuarded)
        OutlinedButton(
          // Offline
          onPressed: () {
            CredentialInit.storage.oaLoginStatus = LoginStatus.offline;
            context.go("/");
          },
          child: i18n.offlineModeBtn.text(),
        ),
    ].row(caa: CrossAxisAlignment.center, maa: MainAxisAlignment.spaceAround);
  }
}

const forgotLoginPasswordUrl =
    "https://authserver.sit.edu.cn/authserver/getBackPasswordMainPage.do?service=https%3A%2F%2Fmyportal.sit.edu.cn%3A443%2F";

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: i18n.forgotPwdBtn.text(
        style: const TextStyle(color: Colors.grey),
      ),
      onPressed: () {
        guardLaunchUrlString(context, forgotLoginPasswordUrl);
      },
    );
  }
}

/// Only allow student ID/ work number.
String? studentIdValidator(String? account, String Function() invalidMessage) {
  if (account != null && account.isNotEmpty) {
    if (guessOaUserType(account) == null) {
      return invalidMessage();
    }
  }
  return null;
}
