import 'package:flutter/material.dart';
import 'package:sit/credential/entity/user_type.dart';
import 'package:sit/credential/widgets/oa_scope.dart';
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
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: i18n.school.title.text(style: context.textTheme.headlineSmall),
            ),
          ),
          SliverList.list(
            children: [
              if (userType?.capability.enableClass2nd == true) buildClass2ndAutoRefreshToggle(),
              if (userType?.capability.enableExamResult == true) buildExamResultShowDetailsToggle(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildClass2ndAutoRefreshToggle() {
    return StatefulBuilder(
      builder: (ctx, setState) => ListTile(
        title: i18n.school.class2nd.autoRefreshTitle.text(),
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

  Widget buildExamResultShowDetailsToggle() {
    return StatefulBuilder(
      builder: (ctx, setState) => ListTile(
        title: i18n.school.examResult.appCardShowResultDetailsTitle.text(),
        subtitle: i18n.school.examResult.appCardShowResultDetailsDesc.text(),
        leading: const Icon(Icons.refresh_outlined),
        trailing: Switch.adaptive(
          value: Settings.school.examResult.appCardShowResultDetails,
          onChanged: (newV) {
            setState(() {
              Settings.school.examResult.appCardShowResultDetails = newV;
            });
          },
        ),
      ),
    );
  }
}
