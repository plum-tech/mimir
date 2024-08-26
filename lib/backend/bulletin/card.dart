import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/widgets/app.dart';

class BulletinAppCard extends ConsumerStatefulWidget {
  const BulletinAppCard({super.key});

  @override
  ConsumerState<BulletinAppCard> createState() => _BulletinAppCardState();
}

class _BulletinAppCardState extends ConsumerState<BulletinAppCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: "Bulletin".text(),
    );
  }
}
