import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/settings/settings.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

class SchoolSettingsPage extends ConsumerStatefulWidget {
  const SchoolSettingsPage({
    super.key,
  });

  @override
  ConsumerState<SchoolSettingsPage> createState() => _SchoolSettingsPageState();
}

class _SchoolSettingsPageState extends ConsumerState<SchoolSettingsPage> {

  @override
  Widget build(BuildContext context) {
    final userType = ref.watch(CredentialsInit.storage.$oaUserType);
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
        leading: Icon(context.icons.refresh),
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
