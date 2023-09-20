import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mimir/credential/entity/email.dart';
import 'package:mimir/credential/init.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/r.dart';
import 'package:mimir/utils/guard_launch.dart';
import 'package:rettulf/rettulf.dart';
import '../init.dart';
import '../i18n.dart';

class EduEmailLoginPage extends StatefulWidget {
  final String? studentId;

  const EduEmailLoginPage({
    super.key,
    required this.studentId,
  });

  @override
  State<EduEmailLoginPage> createState() => _EduEmailLoginPageState();
}

class _EduEmailLoginPageState extends State<EduEmailLoginPage> {
  late final TextEditingController $username = TextEditingController(text: widget.studentId);
  final $password = TextEditingController();
  final GlobalKey _formKey = GlobalKey<FormState>();
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
        resizeToAvoidBottomInset: false,
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
            readOnly: widget.studentId != null,
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
                  ? () {
                      // un-focus the text field.
                      FocusScope.of(context).requestFocus(FocusNode());
                      onLogin();
                    }
                  : null,
              icon: const Icon(Icons.login),
              label: i18n.loginBtn.text().padAll(5),
            );
  }

  Future<void> onLogin() async {
    final credential = EmailCredentials(
      address: R.formatEduEmail(username: $username.text),
      password: $password.text,
    );
    try {
      await EduEmailInit.service.login(credential);
    } catch (err) {
      if (!mounted) return;
      await context.showTip(title: i18n.failedWarn, desc: "please check your pwd", ok: i18n.ok);
      return;
    }
    CredentialInit.storage.eduEmailCredentials = credential;
  }
}

const forgotLoginPasswordUrl =
    "http://imap.mail.sit.edu.cn//edu_reg/retrieve/redirect?redirectURL=http://imap.mail.sit.edu.cn/coremail/index.jsp";

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
