import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/backend/user/entity/verify.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/utils/save.dart';
import 'package:rettulf/rettulf.dart';

import '../../init.dart';

class MimirLoginPage extends ConsumerStatefulWidget {
  const MimirLoginPage({super.key});

  @override
  ConsumerState createState() => _MimirLoginPageState();
}

class _MimirLoginPageState extends ConsumerState<MimirLoginPage> {
  MimirAuthMethods? authMethods;

  @override
  void initState() {
    super.initState();
    fetchAuthMethods();
  }

  Future<void> fetchAuthMethods() async {
    final authMethods = await BackendInit.login.fetchAuthMethods();
    setState(() {
      this.authMethods = authMethods;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PromptSaveBeforeQuitScope(
      changed: true,
      onSave: () {},
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          toolbarHeight: 90,
          title: buildSchoolSelector(),
        ),
        body: [
          buildHeader(),
          const Divider(),
          buildLoginForm().padAll(8).expanded(),
        ].column(),
      ),
    );
  }

  Widget buildHeader() {
    final authMethods = this.authMethods;
    return [
      "Login SIT Life".text(
        style: context.textTheme.displaySmall,
        textAlign: TextAlign.center,
      ),
      const Padding(padding: EdgeInsets.only(top: 40)),
      if (authMethods != null) buildAuthSegments(authMethods),
      // buildSchoolIdField(),
    ].column(caa: CrossAxisAlignment.center, maa: MainAxisAlignment.center).center().padAll(8);
  }

  Widget buildLoginForm() {
    return SchoolIdLoginForm();
  }

  Widget buildAuthSegments(MimirAuthMethods methods) {
    return SegmentedButton(
      segments: [
        if (methods.schoolId != null)
          ButtonSegment(
            label: "School ID".text(),
            value: "school-id",
            enabled: methods.schoolId == true,
          ),
        ButtonSegment(
          label: "Phone".text(),
          value: "phone-number",
          enabled: false,
        ),
      ],
      selected: const {"school-id"},
      onSelectionChanged: (newSelection) {},
    );
  }

  Widget buildPhoneNumber() {
    return FilledButton(
      onPressed: () {},
      child: "Phone Number".text(),
    );
  }

  Widget buildSchoolSelector() {
    return DropdownMenu<String>(
      label: "School".text(),
      initialSelection: "10259",
      onSelected: (String? newSelection) {
        print(newSelection);
      },
      dropdownMenuEntries: [
        DropdownMenuEntry<String>(
          value: "10259",
          label: "SIT",
        )
      ],
    );
  }
}

class SchoolIdLoginForm extends ConsumerStatefulWidget {
  const SchoolIdLoginForm({super.key});

  @override
  ConsumerState createState() => _SchoolIdLoginFormState();
}

class _SchoolIdLoginFormState extends ConsumerState<SchoolIdLoginForm> {
  final $schoolId = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return [
      buildSchoolIdField(),
    ].column();
  }

  Widget buildSchoolIdField() {
    return TextFormField(
      controller: $schoolId,
      autofillHints: const [AutofillHints.username],
      textInputAction: TextInputAction.next,
      autocorrect: false,
      // readOnly: isLoggingIn,
      enableSuggestions: false,
      // validator: (account) => studentIdValidator(account, () => i18n.invalidAccountFormat),
      decoration: InputDecoration(
        labelText: "School ID",
        hintText: "Student ID/Worker ID",
        icon: Icon(context.icons.person),
      ),
    );
  }
}
