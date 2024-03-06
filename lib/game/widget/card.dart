import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/widgets/app.dart';

class GameAppCard extends StatelessWidget {
  final String name;
  final String baseRoute;

  const GameAppCard({
    super.key,
    required this.baseRoute,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: name.text(),
      leftActions: [
        FilledButton(
            onPressed: () {
              context.push("/game$baseRoute");
            },
            child: "New game".text())
      ],
    );
  }
}
