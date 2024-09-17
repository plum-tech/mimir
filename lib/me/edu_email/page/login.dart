import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/entity/user_type.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/credentials/utils.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/animation/animated.dart';
import 'package:mimir/login/utils.dart';
import 'package:mimir/login/widget/forgot_pwd.dart';
import 'package:mimir/r.dart';
import 'package:mimir/school/utils.dart';
import 'package:mimir/widget/markdown.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/settings/dev.dart';
import 'package:mimir/utils/error.dart';
import '../init.dart';
import '../i18n.dart';

const _forgotLoginPasswordUrl =
    "http://imap.mail.sit.edu.cn//edu_reg/retrieve/redirect?redirectURL=http://imap.mail.sit.edu.cn/coremail/index.jsp";

class EduEmailLoginPage extends StatefulWidget {
  const EduEmailLoginPage({super.key});

  @override
  State<EduEmailLoginPage> createState() => _EduEmailLoginPageState();
}

class _EduEmailLoginPageState extends State<EduEmailLoginPage> {
  final initialAccount = CredentialsInit.storage.oa.credentials?.account;
  late final $username = TextEditingController(text: initialAccount);
  final $password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordClear = false;
  bool loggingIn = false;
  OaUserType? estimatedUserType;
  int? admissionYear;

  @override
  void initState() {
    super.initState();
    $username.addListener(onUsernameChange);
  }

  @override
  void dispose() {
    $username.dispose();
    $password.dispose();
    super.dispose();
  }

  void onUsernameChange() {
    var account = $username.text;
    account = account.toUpperCase();
    if (account != $username.text) {
      $username.text = account;
    }
    setState(() {
      estimatedUserType = estimateOaUserType(account);
      admissionYear = getAdmissionYearFromStudentId(account);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // dismiss the keyboard when tap out of TextField.
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: buildBody(),
    );
  }

  Widget buildBody() {
    if (context.isPortrait) {
      return Scaffold(
        appBar: AppBar(
          title: i18n.login.title.text(),
        ),
        floatingActionButton: !loggingIn ? null : const CircularProgressIndicator.adaptive(),
        body: [
          buildForm(),
          const SizedBox(height: 10),
          const EduEmailLoginDisclaimerCard(),
          AnimatedShowUp(
            when: estimatedUserType == OaUserType.undergraduate && admissionYear == DateTime.now().year,
            builder: (ctx) => const EduEmailFreshmanTipCard(),
          ),
          buildLoginButton(),
          const ForgotPasswordButton(url: _forgotLoginPasswordUrl),
        ].column(mas: MainAxisSize.min).scrolled().padH(10).center(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: i18n.login.title.text(),
        ),
        floatingActionButton: !loggingIn ? null : const CircularProgressIndicator.adaptive(),
        body: [
          [
            const EduEmailLoginDisclaimerCard(),
            AnimatedShowUp(
              when: estimatedUserType == OaUserType.undergraduate && admissionYear == DateTime.now().year,
              builder: (ctx) => const EduEmailFreshmanTipCard(),
            ),
          ].column().scrolled().expanded(),
          const VerticalDivider(),
          [
            buildForm(),
            buildLoginButton(),
            const ForgotPasswordButton(url: _forgotLoginPasswordUrl),
          ].column(mas: MainAxisSize.min).scrolled().expanded()
        ].row(),
      );
    }
  }

  Widget buildForm() {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          children: [
            TextFormField(
              controller: $username,
              textInputAction: TextInputAction.next,
              autofocus: true,
              readOnly: !Dev.on && initialAccount != null,
              autocorrect: false,
              enableSuggestions: false,
              validator: (username) {
                if (username == null) return null;
                if (EmailValidator.validate(R.formatEduEmail(username: username))) return null;
                return i18n.login.invalidEmailAddressFormatTip;
              },
              decoration: InputDecoration(
                labelText: i18n.info.emailAddress,
                hintText: i18n.login.addressHint,
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
                if (!loggingIn) {
                  await onLogin();
                }
              },
              decoration: InputDecoration(
                labelText: i18n.login.credentials.pwd,
                icon: Icon(context.icons.lock),
                hintText: i18n.login.passwordHint,
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
    return $username >>
        (ctx, account) => FilledButton.icon(
              // Online
              onPressed: !loggingIn && account.text.isNotEmpty
                  ? () async {
                      // un-focus the text field.
                      FocusScope.of(context).requestFocus(FocusNode());
                      await onLogin();
                    }
                  : null,
              icon: const Icon(Icons.login),
              label: i18n.login.login.text().padAll(5),
            );
  }

  Future<void> onLogin() async {
    final credential = Credentials(
      account: R.formatEduEmail(username: $username.text),
      password: $password.text,
    );
    try {
      if (!mounted) return;
      setState(() => loggingIn = true);
      await EduEmailInit.service.login(credential);
      CredentialsInit.storage.eduEmail.credentials = credential;
      if (!mounted) return;
      setState(() => loggingIn = false);
      context.replace("/edu-email/inbox");
    } catch (error, stackTrace) {
      debugPrintError(error, stackTrace);
      if (!mounted) return;
      setState(() => loggingIn = false);
      if (error is Exception) {
        await handleLoginException(context: context, error: error, stackTrace: stackTrace);
      }
    }
  }
}

class EduEmailLoginDisclaimerCard extends StatelessWidget {
  const EduEmailLoginDisclaimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return [
      FeaturedMarkdownWidget(
        data: i18n.login.disclaimer,
      ),
    ].column(caa: CrossAxisAlignment.stretch).padAll(12).inOutlinedCard();
  }
}

class EduEmailFreshmanTipCard extends StatelessWidget {
  const EduEmailFreshmanTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return [
      FeaturedMarkdownWidget(
        data: i18n.login.freshmanTip,
      ),
    ].column(caa: CrossAxisAlignment.stretch).padAll(12).inOutlinedCard();
  }
}
