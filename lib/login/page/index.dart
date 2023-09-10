import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credential/entity/credential.dart';
import 'package:mimir/credential/entity/email.dart';
import 'package:mimir/credential/entity/login_status.dart';
import 'package:mimir/credential/init.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/exception/session.dart';
import 'package:mimir/r.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:mimir/utils/validation.dart';
import 'package:rettulf/rettulf.dart';

import '../init.dart';
import '../i18n.dart';

class LoginPage extends StatefulWidget {
  final bool isGuarded;

  const LoginPage({super.key, required this.isGuarded});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text field controllers.
  final TextEditingController $account = TextEditingController();
  final TextEditingController $password = TextEditingController();

  final GlobalKey _formKey = GlobalKey<FormState>();

  // State
  bool isPasswordClear = false;
  bool isLoggingIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final oaCredential = context.auth.credential;
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
      final oaCredential = OaCredential(account: account, password: password);
      await LoginInit.ssoSession.loginActive(oaCredential);
      // final personName = await LoginInit.authServerService.getPersonName();
      if (!mounted) return;
      final auth = context.auth;
      auth.setOaCredential(oaCredential);
      auth.setLoginStatus(LoginStatus.validated);
      // Edu email has the same credential as OA by default.
      // So assume this can work at first time.
      CredentialInit.storage.eduEmailCredential ??= EmailCredential(
        address: R.formatEduEmail(username: oaCredential.account),
        password: oaCredential.password,
      );
      context.go("/");
      setState(() => isLoggingIn = false);
    } on UnknownAuthException catch (e) {
      await context.showTip(
        title: i18n.failedWarn,
        desc: e.msg,
        ok: i18n.close,
      );
    } on CredentialsInvalidException catch (e) {
      if (!mounted) return;
      await context.showTip(
        title: i18n.failedWarn,
        desc: e.msg,
        ok: i18n.close,
      );
      return;
    } catch (e, stacktrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stacktrace);
      if (!mounted) return;
      await context.showTip(
        title: i18n.failedWarn,
        desc: i18n.accountOrPwdIncorrectTip,
        ok: i18n.close,
        serious: true,
      );
    } finally {
      if (mounted) {
        setState(() => isLoggingIn = false);
      }
    }
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
            enableSuggestions: false,
            obscureText: !isPasswordClear,
            onFieldSubmitted: (inputted) {
              if (!isLoggingIn) {
                onLogin();
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
          (ctx, account) => ElevatedButton(
                // Online
                onPressed: !isLoggingIn && account.text.isNotEmpty
                    ? () {
                        // un-focus the text field.
                        FocusScope.of(context).requestFocus(FocusNode());
                        onLogin();
                      }
                    : null,
                child: isLoggingIn ? const CircularProgressIndicator() : i18n.loginBtn.text().padAll(5),
              ),
      if (!widget.isGuarded)
        ElevatedButton(
          // Offline
          onPressed: () {
            context.auth.setLoginStatus(LoginStatus.offline);
            context.go("/");
          },
          child: i18n.offlineModeBtn.text().padAll(5),
        ),
    ].row(caa: CrossAxisAlignment.center, maa: MainAxisAlignment.spaceAround);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isGuarded ? i18n.loginRequired.text() : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push("/settings");
            },
          ),
        ],
      ),
      body: buildBody(),
      //to avoid overflow when keyboard is up.
      bottomNavigationBar: [
        const ForgotPasswordButton(),
      ].wrap(align: WrapAlignment.center).padAll(10),
    );
  }

  Widget buildBody() {
    return [
      widget.isGuarded ? buildOfflineIcon() : buildTitle(),
      Padding(padding: EdgeInsets.only(top: 40.h)),
      // Form field: username and password.
      buildLoginForm(),
      SizedBox(height: 10.h),
      buildLoginButton(),
    ]
        .column(mas: MainAxisSize.min)
        .scrolled(physics: const NeverScrollableScrollPhysics())
        .padH(25.h)
        .center()
        .safeArea();
  }

  Widget buildTitle() {
    return i18n.title.text(
      style: context.textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }

  Widget buildOfflineIcon() {
    return const Icon(
      Icons.person_off_outlined,
      size: 120,
    );
  }

  @override
  void dispose() {
    super.dispose();
    $account.dispose();
    $password.dispose();
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
