import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/feature/feature.dart';
import 'package:mimir/settings/settings.dart';
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
    final userType = ref.watch(CredentialsInit.storage.oa.$userType);
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: [
          SliverAppBar.large(
            pinned: true,
            snap: false,
            floating: false,
            title: i18n.navigation.text(),
          ),
          SliverList.list(
            children: [
              if (userType.has(AppFeature.secondClass$)) buildClass2ndAutoRefreshToggle(),
              if (userType.has(AppFeature.examResult$)) buildExamResultShowResultPreviewToggle(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildClass2ndAutoRefreshToggle() {
    return StatefulBuilder(
      builder: (ctx, setState) => ListTile(
        title: i18n.settings.class2nd.autoRefresh.text(),
        subtitle: i18n.settings.class2nd.autoRefreshDesc.text(),
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
        title: i18n.settings.examResult.showResultPreview.text(),
        subtitle: i18n.settings.examResult.showResultPreviewDesc.text(),
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
