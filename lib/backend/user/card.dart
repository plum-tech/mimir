import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/backend/user/x.dart';
import 'package:mimir/credentials/init.dart';
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
  void initState() {
    super.initState();
    if (CredentialsInit.storage.mimir.signedIn == true) {
      XMimirUser.verifyAuth(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final signedIn = ref.watch(CredentialsInit.storage.mimir.$signedIn);
    if (signedIn) {
      return AppCard(
        title: "Your profile".text(),
        leftActions: [],
      );
    } else {
      return const MimirLoginAppCard();
    }
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
      title: "Sign in Ing Account".text(),
      leftActions: [
        FilledButton.icon(
          icon: const Icon(Icons.login),
          onPressed: () async {
            await XMimirUser.signIn(context);
          },
          label: "Sign in".text(),
        ),
      ],
    );
  }
}
