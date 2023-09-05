import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';

class MePage extends StatefulWidget {
  const MePage({super.key});

  @override
  State<MePage> createState() => _MePageState();
}

class _MePageState extends State<MePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          snap: false,
          floating: false,
          expandedHeight: 100.0,
          flexibleSpace: FlexibleSpaceBar(
            title: "Me".text(style: context.textTheme.headlineSmall),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.push("/settings");
              },
            ),
          ],
        )
      ],
    );
  }
}
