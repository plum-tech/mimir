import 'package:flutter/material.dart';
import 'package:sit/credentials/entity/user_type.dart';
import 'package:sit/credentials/widgets/oa_scope.dart';
import 'package:sit/settings/settings.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

class SchoolSettingsPage extends StatefulWidget {
  const SchoolSettingsPage({
    super.key,
  });

  @override
  State<SchoolSettingsPage> createState() => _SchoolSettingsPageState();
}

class _SchoolSettingsPageState extends State<SchoolSettingsPage> {
  OaUserType? userType;

  @override
  void didChangeDependencies() {
    final auth = context.auth;
    final newUserType = auth.userType;
    if (userType != newUserType) {
      setState(() {
        userType = newUserType;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            pinned: true,
            snap: false,
            floating: false,
            title: i18n.school.title.text(),
          ),
          SliverList.list(
            children: [
              if (userType?.capability.enableClass2nd == true) buildClass2ndAutoRefreshToggle(),
              if (userType?.capability.enableExamResult == true) buildExamResultShowResultPreviewToggle(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildClass2ndAutoRefreshToggle() {
    return StatefulBuilder(
      builder: (ctx, setState) => ListTile(
        title: i18n.school.class2nd.autoRefresh.text(),
        subtitle: i18n.school.class2nd.autoRefreshDesc.text(),
        leading: const Icon(Icons.refresh_outlined),
        trailing: Switch.adaptive(
          value: Settings.school.class2nd.autoRefresh,
          onChanged: (newV) {
            setState(() {
              Settings.school.class2nd.autoRefresh = newV;
            });
          },
        ),
      ),
    );
  }

  Widget buildExamResultShowResultPreviewToggle() {
    return StatefulBuilder(
      builder: (ctx, setState) => ListTile(
        title: i18n.school.examResult.showResultPreview.text(),
        subtitle: i18n.school.examResult.showResultPreviewDesc.text(),
        leading: const Icon(Icons.preview),
        trailing: Switch.adaptive(
          value: Settings.school.examResult.showResultPreview,
          onChanged: (newV) {
            setState(() {
              Settings.school.examResult.showResultPreview = newV;
            });
          },
        ),
      ),
    );
  }
}
