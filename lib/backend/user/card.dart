import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/backend/user/x.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:rettulf/rettulf.dart';

import "i18n.dart";

class UserProfileAppCard extends ConsumerStatefulWidget {
  const UserProfileAppCard({super.key});

  @override
  ConsumerState createState() => _UserProfileAppCardState();
}

class _UserProfileAppCardState extends ConsumerState<UserProfileAppCard> {
  @override
  Widget build(BuildContext context) {
    return const MimirLoginAppCard();
    return AppCard(
      title: "Login SIT Life".text(),
      leftActions: [],
    );
  }
}

class MimirLoginAppCard extends ConsumerStatefulWidget {
  const MimirLoginAppCard({super.key});

  @override
  ConsumerState createState() => _MimirLoginAppCardState();
}

class _MimirLoginAppCardState extends ConsumerState<MimirLoginAppCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: "Login SIT Life".text(),
      leftActions: [
        FilledButton.icon(
          icon: const Icon(Icons.login),
          onPressed: () async {
            await XMimirUser.signIn(context);
          },
          label: "Login".text(),
        ),
      ],
    );
  }
}
