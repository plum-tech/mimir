import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/app.dart';

class ForumAppCard extends ConsumerStatefulWidget {
  const ForumAppCard({super.key});

  @override
  ConsumerState<ForumAppCard> createState() => _ForumAppCardState();
}

class _ForumAppCardState extends ConsumerState<ForumAppCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: "小应社区".text(),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            await context.push("/forum");
          },
          label: "进入".text(),
          icon: Icon(context.icons.home),
        ),
      ],
    );
  }
}
