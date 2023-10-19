import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credentials/entity/email.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/r.dart';
import 'package:sit/utils/guard_launch.dart';
import 'package:rettulf/rettulf.dart';
import '../init.dart';
import '../i18n.dart';

class EduEmailLoginPage extends StatefulWidget {
  const EduEmailLoginPage({super.key});

  @override
  State<EduEmailLoginPage> createState() => _EduEmailLoginPageState();
}

class _EduEmailLoginPageState extends State<EduEmailLoginPage> {
  final initialAccount = CredentialInit.storage.oaCredentials?.account;
  late final $username = TextEditingController(text: initialAccount);
  final $password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordClear = false;
  bool isLoggingIn = false;

  @override
  void dispose() {
    $username.dispose();
    $password.dispose();
    super.dispose();
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
          title: i18n.login.title.text(),
          bottom: isLoggingIn
              ? const PreferredSize(
                  preferredSize: Size.fromHeight(4),
                  child: LinearProgressIndicator(),
                )
              : null,
        ),
        body: buildBody(),
        bottomNavigationBar: const ForgotPasswordButton(),
      ),
    );
  }

  Widget buildBody() {
    return [
      buildForm(),
      SizedBox(height: 10.h),
      buildLoginButton(),
    ].column(mas: MainAxisSize.min).scrolled(physics: const NeverScrollableScrollPhysics()).padH(25.h).center();
  }

  Widget buildForm() {
    // TODO: i18n
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: $username,
            textInputAction: TextInputAction.next,
            autofocus: true,
            readOnly: initialAccount != null,
            autocorrect: false,
            enableSuggestions: false,
            validator: (username) {
              if (username == null) return null;
              if (EmailValidator.validate(R.formatEduEmail(username: username))) return null;
              return "invalid email address format";
            },
            decoration: InputDecoration(
              labelText: "Email Address",
              hintText: "your Student ID",
              suffixText: "@${R.eduEmailDomain}",
              icon: const Icon(Icons.alternate_email_outlined),
            ),
          ),
          TextFormField(
            controller: $password,
            autofocus: true,
            keyboardType: isPasswordClear ? TextInputType.visiblePassword : null,
            textInputAction: TextInputAction.send,
            contextMenuBuilder: (ctx, state) {
              return AdaptiveTextSelectionToolbar.editableText(
                editableTextState: state,
              );
            },
            autocorrect: false,
            enableSuggestions: false,
            obscureText: !isPasswordClear,
            onFieldSubmitted: (inputted) async {
              if (!isLoggingIn) {
                await onLogin();
              }
            },
            decoration: InputDecoration(
              labelText: "Password",
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
    return $username >>
        (ctx, account) => FilledButton.icon(
              // Online
              onPressed: !isLoggingIn && account.text.isNotEmpty
                  ? () async {
                      // un-focus the text field.
                      FocusScope.of(context).requestFocus(FocusNode());
                      await onLogin();
                    }
                  : null,
              icon: const Icon(Icons.login),
              label: i18n.login.loginBtn.text().padAll(5),
            );
  }

  Future<void> onLogin() async {
    final credential = EmailCredentials(
      address: R.formatEduEmail(username: $username.text),
      password: $password.text,
    );
    try {
      if (!mounted) return;
      setState(() => isLoggingIn = true);
      await EduEmailInit.service.login(credential);
      CredentialInit.storage.eduEmailCredentials = credential;
      if (!mounted) return;
      setState(() => isLoggingIn = false);
      context.replace("/edu-email/inbox");
    } catch (err) {
      if (!mounted) return;
      await context.showTip(title: i18n.login.failedWarn, desc: "please check your pwd", ok: i18n.ok);
      if (!mounted) return;
      setState(() => isLoggingIn = false);
      return;
    }
  }
}

const forgotLoginPasswordUrl =
    "http://imap.mail.sit.edu.cn//edu_reg/retrieve/redirect?redirectURL=http://imap.mail.sit.edu.cn/coremail/index.jsp";

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformTextButton(
      child: i18n.login.forgotPwdBtn.text(
        style: const TextStyle(color: Colors.grey),
      ),
      onPressed: () {
        guardLaunchUrlString(context, forgotLoginPasswordUrl);
      },
    );
  }
}
