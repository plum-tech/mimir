import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:rettulf/rettulf.dart';

class StudentPlanAppCard extends StatefulWidget {
  const StudentPlanAppCard({super.key});

  @override
  State<StudentPlanAppCard> createState() => _StudentPlanAppCardState();
}

class _StudentPlanAppCardState extends State<StudentPlanAppCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: "Student plan".text(),
      leftActions: [
        FilledButton.icon(
          onPressed: () async {
            context.push("/select-course");
          },
          label: "Select course".text(),
          icon: const Icon(Icons.select_all),
        ),
        FilledButton.tonal(
          onPressed: null,
          child: "Plan".text(),
        )
      ],
    );
  }
}
