import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/adaptive/menu.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/school/i18n.dart' as $school;
import 'package:mimir/me/i18n.dart' as $me;
import 'package:mimir/settings/i18n.dart' as $settings;

List<PullDownEntry> buildFocusPopupActions(BuildContext context) {
  return [
    const PullDownDivider(),
    PullDownItem(
      icon: context.icons.person,
      title: $me.i18n.navigation,
      onTap: () async {
        await context.push("/me");
      },
    ),
    PullDownItem(
      icon: Icons.school_outlined,
      title: $school.i18n.navigation,
      onTap: () async {
        await context.push("/school");
      },
    ),
    PullDownItem(
      icon: context.icons.settings,
      title: $settings.i18n.title,
      onTap: () async {
        await context.push("/settings");
      },
    ),
  ];
}
