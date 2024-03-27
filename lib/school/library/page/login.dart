import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credentials/entity/credential.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/login/utils.dart';
import 'package:sit/login/widgets/forgot_pwd.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/school/library/api.dart';
import 'package:sit/utils/error.dart';
import '../init.dart';
import '../i18n.dart';

class LibraryLoginPage extends StatefulWidget {
  const LibraryLoginPage({super.key});

  @override
  State<LibraryLoginPage> createState() => _LibraryLoginPageState();
}

class _LibraryLoginPageState extends State<LibraryLoginPage> {
  final initialAccount = CredentialsInit.storage.oaCredentials?.account;
  late final $readerId = TextEditingController(text: initialAccount);
  final $password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordClear = false;
  bool isLoggingIn = false;

  @override
  void dispose() {
    $readerId.dispose();
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
        bottomNavigationBar: const ForgotPasswordButton(url: LibraryApi.forgotLoginPasswordUrl),
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
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: _formKey,
      child: AutofillGroup(
        child: Column(
          children: [
            TextFormField(
              controller: $readerId,
              textInputAction: TextInputAction.next,
              autofocus: true,
              readOnly: !kDebugMode && initialAccount != null,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: i18n.readerId,
                hintText: i18n.login.readerIdHint,
                icon: const Icon(Icons.chrome_reader_mode),
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
                labelText: i18n.login.credentials.pwd,
                hintText: i18n.login.passwordHint,
                icon: Icon(context.icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(isPasswordClear ? context.icons.eyeSolid: context.icons.eyeSlashSolid),
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
    return $readerId >>
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
              label: i18n.login.login.text().padAll(5),
            );
  }

  Future<void> onLogin() async {
    final credential = Credentials(
      account: $readerId.text,
      password: $password.text,
    );
    try {
      if (!mounted) return;
      setState(() => isLoggingIn = true);
      await LibraryInit.auth.login(credential);
      CredentialsInit.storage.libraryCredentials = credential;
      if (!mounted) return;
      setState(() => isLoggingIn = false);
      context.replace("/library/borrowing");
    } catch (error, stackTrace) {
      handleRequestError(context, error, stackTrace);
      if (!mounted) return;
      setState(() => isLoggingIn = false);
      if (error is Exception) {
        handleLoginException(context: context, error: error, stackTrace: stackTrace);
      }
      return;
    }
  }
}
