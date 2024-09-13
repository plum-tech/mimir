import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/backend/user/entity/verify.dart';
import 'package:mimir/backend/user/x.dart';
import 'package:mimir/settings/entity/agreements.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/design/animation/animated.dart';
import 'package:mimir/login/page/index.dart';
import 'package:mimir/login/widgets/forgot_pwd.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/utils/save.dart';
import 'package:mimir/settings/widget/agreements.dart';
import 'package:mimir/widgets/markdown.dart';
import 'package:rettulf/rettulf.dart';

import '../../init.dart';
import '../../entity/user.dart';
import "../../i18n.dart";

class MimirSignInPage extends ConsumerStatefulWidget {
  const MimirSignInPage({super.key});

  @override
  ConsumerState createState() => _MimirSignInPageState();
}

class _MimirSignInPageState extends ConsumerState<MimirSignInPage> {
  MimirAuthMethods? authMethods;
  var school = SchoolCode.sit;
  var signingIn = false;
  MimirAuthMethod? authMethod;

  @override
  void initState() {
    super.initState();
    fetchAuthMethods();
  }

  Future<void> fetchAuthMethods() async {
    setState(() {
      this.authMethods = null;
    });
    final authMethods = await BackendInit.auth.fetchAuthMethods(school: school);
    setState(() {
      this.authMethods = authMethods;
      authMethod = authMethods.availableMethods.firstOrNull;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PromptDiscardBeforeQuitScope(
      changed: true,
      child: GestureDetector(
        onTap: () {
          // dismiss the keyboard when tap out of TextField.
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    if (context.isPortrait) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 90,
          title: buildSchoolSelector(),
          actions: [
            buildHelp(),
          ],
        ),
        floatingActionButton: signingIn ? const CircularProgressIndicator.adaptive() : null,
        body: [
          buildHeader(),
          buildAuthMethods(),
          const Divider(),
          AnimatedSwitcher(
            duration: Durations.medium2,
            child: buildLoginForm(),
          ).padAll(12),
        ].listview(),
        bottomNavigationBar: const BottomAppBar(child: AgreementsCheckBox.account()),
      );
    } else {
      return Scaffold(
        appBar: AppBar(),
        floatingActionButton: signingIn ? const CircularProgressIndicator.adaptive() : null,
        bottomNavigationBar: const BottomAppBar(height: 50, child: AgreementsCheckBox.account()),
        body: [
          [
            buildHeader(),
            buildSchoolSelector(),
            buildAuthMethods(),
          ].column(caa: CrossAxisAlignment.center, maa: MainAxisAlignment.spaceEvenly).expanded(),
          const VerticalDivider(),
          [
            AnimatedSwitcher(
              duration: Durations.medium2,
              child: buildLoginForm(),
            ).padAll(8),
          ].column().scrolled().expanded(),
        ].row(),
      );
    }
  }

  Widget buildHelp() {
    return PlatformIconButton(
      icon: const Icon(Icons.help),
      onPressed: () {},
    );
  }

  Widget buildHeader() {
    return i18n.auth.signInTitle
        .text(
          style: context.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        )
        .padSymmetric(v: 20);
  }

  Widget buildAuthMethods() {
    final authMethods = this.authMethods;
    final authMethod = this.authMethod;
    return AnimatedSwitcher(
      duration: Durations.medium2,
      child: authMethods != null
          ? authMethod != null
              ? buildAuthSegments(authMethods, authMethod)
              : i18n.auth.authMethodsAvailable
                  .text(
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleMedium,
                  )
                  .padH(20)
          : const CircularProgressIndicator.adaptive(),
    );
  }

  Widget buildLoginForm() {
    final authMethod = this.authMethod;
    if (authMethods == null) {
      return const CircularProgressIndicator.adaptive().center();
    }
    if (authMethod == null) {
      return const SizedBox.shrink();
    }
    return switch (authMethod) {
      MimirAuthMethod.schoolId => SchoolIdSignInForm(
          school: school,
          signingIn: signingIn,
          onSigningIn: (value) {
            setState(() {
              signingIn = value;
            });
          },
        ),
      MimirAuthMethod.eduEmail => const UnimplementedSignInForm(),
      MimirAuthMethod.phoneNumber => const UnimplementedSignInForm(),
    };
  }

  Widget buildAuthSegments(MimirAuthMethods methods, MimirAuthMethod selected) {
    return SegmentedButton<MimirAuthMethod>(
      segments: methods.supportedMethods
          .map((m) => ButtonSegment(
                label: m.l10n().text(),
                value: m,
                enabled: methods.isAvailable(m),
              ))
          .toList(),
      selected: {selected},
      onSelectionChanged: (newSelection) {
        setState(() {
          authMethod = newSelection.first;
        });
      },
    );
  }

  Widget buildSchoolSelector() {
    return DropdownMenu<SchoolCode>(
      label: i18n.school.text(),
      initialSelection: school,
      onSelected: (newSelection) {
        final selected = newSelection ?? SchoolCode.sit;
        if (school != selected) {
          setState(() {
            school = selected;
          });
          fetchAuthMethods();
        }
      },
      dropdownMenuEntries: SchoolCode.values
          .map((school) => DropdownMenuEntry<SchoolCode>(
                value: school,
                label: school.l10n(),
              ))
          .toList(),
    );
  }
}

class SchoolIdSignInForm extends ConsumerStatefulWidget {
  final SchoolCode school;
  final bool signingIn;
  final ValueChanged<bool> onSigningIn;

  const SchoolIdSignInForm({
    super.key,
    required this.school,
    this.signingIn = false,
    required this.onSigningIn,
  });

  @override
  ConsumerState createState() => _SchoolIdSignInFormState();
}

enum _SignInStatus {
  none,
  notFound,
  existing,
}

class _SchoolIdSignInFormState extends ConsumerState<SchoolIdSignInForm> {
  final $schoolId = TextEditingController(text: CredentialsInit.storage.oa.credentials?.account);
  final $password = TextEditingController(text: CredentialsInit.storage.oa.credentials?.password);
  bool isPasswordClear = false;
  var status = _SignInStatus.none;
  final $schoolIdForm = GlobalKey<FormState>();
  var checkingExisting = false;

  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  @override
  void dispose() {
    $schoolId.dispose();
    $password.dispose();
    super.dispose();
  }

  Widget buildBody() {
    final widgets = [
      AutofillGroup(
        child: Form(
          key: $schoolIdForm,
          child: [
            buildSchoolId(),
            AnimatedShowUp(
              when: status != _SignInStatus.none,
              builder: (context) => buildPassword().padV(8),
            ),
          ].column(),
        ),
      ),
      AnimatedShowUp(
        when: status != _SignInStatus.none,
        builder: (context) => const MimirSchoolIdDisclaimerCard().padV(8),
      ),
      AnimatedShowUp(
        when: status == _SignInStatus.existing,
        builder: (context) => buildSignIn().padV(8),
      ),
      AnimatedShowUp(
        when: status == _SignInStatus.notFound,
        builder: (context) => buildSignUp().padV(8),
      ),
      const ForgotPasswordButton(url: oaForgotLoginPasswordUrl).padV(8),
    ];
    return widgets.column(
      maa: MainAxisAlignment.spaceEvenly,
    );
  }

  Future<void> checkExisting() async {
    final schoolId = $schoolId.text;
    if ($schoolIdForm.currentState?.validate() != true) {
      return;
    }
    FocusScope.of(context).requestFocus(FocusNode());
    widget.onSigningIn(true);
    try {
      final existing = await BackendInit.auth.checkExistingBySchoolId(
        school: widget.school,
        schoolId: schoolId,
      );
      setState(() {
        status = existing ? _SignInStatus.existing : _SignInStatus.notFound;
      });
    } finally {
      widget.onSigningIn(false);
    }
  }

  Widget buildSchoolId() {
    return [
      buildSchoolIdForm().expanded(),
      if (status == _SignInStatus.none)
        $schoolId >>
            (ctx, $schoolId) => IconButton.filledTonal(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: $schoolId.text.isEmpty || widget.signingIn ? null : checkExisting,
                ),
    ].row();
  }

  Widget buildSchoolIdForm() {
    return TextFormField(
      controller: $schoolId,
      autofillHints: const [AutofillHints.username],
      textInputAction: TextInputAction.next,
      autocorrect: false,
      readOnly: widget.signingIn,
      enableSuggestions: false,
      validator: (account) => studentIdValidator(account, () => i18n.auth.invalidAccountFormat),
      decoration: InputDecoration(
        labelText: "School ID",
        hintText: "Student ID/Worker ID",
        icon: Icon(context.icons.person),
      ),
      onChanged: (text) async {
        setState(() {
          status = _SignInStatus.none;
        });
      },
      onFieldSubmitted: (text) async {
        await checkExisting();
      },
    );
  }

  Widget buildPassword() {
    return TextFormField(
      controller: $password,
      keyboardType: isPasswordClear ? TextInputType.visiblePassword : null,
      autofillHints: const [AutofillHints.password],
      textInputAction: TextInputAction.send,
      readOnly: widget.signingIn,
      contextMenuBuilder: (ctx, state) {
        return AdaptiveTextSelectionToolbar.editableText(
          editableTextState: state,
        );
      },
      autocorrect: false,
      enableSuggestions: false,
      obscureText: !isPasswordClear,
      onFieldSubmitted: (inputted) async {
        if (status == _SignInStatus.existing) {
          await signIn();
        } else {
          await signUp();
        }
      },
      decoration: InputDecoration(
        labelText: "Password",
        hintText: "School password",
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
    );
  }

  Widget buildSignIn() {
    final acceptedAgreements = ref.watch(Settings.agreements.$AgreementsAcceptanceOf(AgreementsType.account)) ?? false;
    return FilledButton.icon(
      onPressed: !acceptedAgreements || widget.signingIn ? null : signIn,
      icon: const Icon(Icons.login),
      label: i18n.auth.signIn.text(),
    );
  }

  Widget buildSignUp() {
    final acceptedAgreements = ref.watch(Settings.agreements.$AgreementsAcceptanceOf(AgreementsType.account)) ?? false;
    return FilledButton.icon(
      onPressed: !acceptedAgreements || widget.signingIn ? null : signUp,
      icon: const Icon(Icons.create),
      label: i18n.auth.signUp.text(),
    );
  }

  Future<void> signIn() async {
    final acceptedAgreements = ref.read(Settings.agreements.$AgreementsAcceptanceOf(AgreementsType.account)) ?? false;
    if (!acceptedAgreements) {
      await showAgreementsRequired2Accept(context);
      return;
    }

    widget.onSigningIn(true);
    final success = await XMimirUser.signInMimir(
      context,
      school: widget.school,
      schoolId: $schoolId.text,
      password: $password.text,
    );
    if (!mounted) return;
    if (success) {
      context.pop();
    }
    widget.onSigningIn(false);
  }

  Future<void> signUp() async {
    final acceptedAgreements = ref.read(Settings.agreements.$AgreementsAcceptanceOf(AgreementsType.account)) ?? false;
    if (!acceptedAgreements) {
      await showAgreementsRequired2Accept(context);
      return;
    }

    if (!widget.signingIn) return;
    widget.onSigningIn(true);
    final success = await XMimirUser.signUpMimir(
      context,
      school: widget.school,
      schoolId: $schoolId.text,
      password: $password.text,
    );
    if (!mounted) return;
    if (success) {
      context.pop();
    }
    widget.onSigningIn(false);
  }
}

class MimirSchoolIdDisclaimerCard extends StatelessWidget {
  const MimirSchoolIdDisclaimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return [
      FeaturedMarkdownWidget(
        data: i18n.auth.schoolIdDisclaimer,
      ),
    ].column(caa: CrossAxisAlignment.stretch).padAll(12).inOutlinedCard();
  }
}

class UnimplementedSignInForm extends StatelessWidget {
  const UnimplementedSignInForm({super.key});

  @override
  Widget build(BuildContext context) {
    return i18n.auth.authMethodUnimpl.text(
      textAlign: TextAlign.center,
      style: context.textTheme.titleMedium,
    );
  }
}
