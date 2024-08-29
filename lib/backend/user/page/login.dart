import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/backend/user/entity/verify.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: "Login SIT Life".text(),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    final authMethods = this.authMethods;
    return [
      buildSchoolSelector(),
      if (authMethods != null) buildAuthButtons(authMethods),
    ].column().padAll(8);
  }

  Widget buildAuthButtons(MimirAuthMethods methods) {
    return [
      if (methods.schoolId)
        FilledButton(
          onPressed: () {},
          child: "School Id".text(),
        ),
    ].wrap();
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
