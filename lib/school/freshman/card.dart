import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/backend/bulletin/page/list.dart';
import 'package:mimir/backend/forum/card.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:text_scroll/text_scroll.dart';

class FreshmanAppCard extends ConsumerStatefulWidget {
  const FreshmanAppCard({super.key});

  @override
  ConsumerState<FreshmanAppCard> createState() => _FreshmanAppCardState();
}

class _FreshmanAppCardState extends ConsumerState<FreshmanAppCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: "Freshman".text(),
      leftActions: [
        FilledButton.icon(
          onPressed: () {},
          icon: Icon(context.icons.refresh),
          label: "Refresh".text(),
        ),
      ],
    );
  }
}
