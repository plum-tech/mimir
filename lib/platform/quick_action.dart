import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/feature/feature.dart';
import 'package:mimir/life/lab_door/card.dart';
import 'package:mimir/lifecycle.dart';
import 'package:mimir/settings/dev.dart';
import 'package:quick_actions/quick_actions.dart';

import "package:mimir/network/i18n.dart" as $net;
import "package:mimir/me/edu_email/i18n.dart" as $email;
import "package:mimir/backend/i18n.dart" as $mimir;

class QuickAction {
  final String type;
  final void Function(BuildContext context) action;
  final String Function() l10n;
  final bool Function() enable;

  const QuickAction({
    required this.type,
    required this.action,
    required this.l10n,
    required this.enable,
  });

  factory QuickAction.route({
    required String type,
    required String route,
    required String Function() l10n,
    required bool Function() enable,
  }) {
    return QuickAction(
      type: type,
      action: (context) => context.push(route),
      l10n: l10n,
      enable: enable,
    );
  }
}

final _actions = [
  QuickAction(
    type: AppFeature.sitRobotOpenLabDoor,
    action: (ctx) {
      sitRobotOpenDoor();
    },
    l10n: () => "机协开门",
    enable: () {
      final oa = CredentialsInit.storage.oa.credentials;
      if (oa == null) return false;
      return OpenLabDoorAppCard.isAvailable(oaAccount: oa.account);
    },
  ),
  QuickAction.route(
    type: "/tools/network-tool",
    route: "/tools/network-tool",
    l10n: () => $net.i18n.title,
    enable: () => true,
  ),
  QuickAction.route(
    type: "/edu-email/inbox",
    route: "/edu-email/inbox",
    l10n: () => $email.i18n.title,
    enable: () => CredentialsInit.storage.eduEmail.credentials != null,
  ),
  QuickAction.route(
    type: "/mimir/forum",
    route: "/mimir/forum",
    l10n: () => $mimir.i18n.forum.title,
    enable: () => Dev.on,
  ),
];

const _quickActions = QuickActions();

Future<void> initQuickActions() async {
  await _quickActions.initialize((type) async {
    final context = $key.currentContext;
    if (context == null) return;
    final action = _actions.firstWhereOrNull((action) => action.type == type);
    if (action == null) return;
    action.action(context);
  });
  await _quickActions.setShortcutItems(_actions.where((action) => action.enable()).map((action) {
    return ShortcutItem(
      type: action.type,
      localizedTitle: action.l10n(),
    );
  }).toList());
}
