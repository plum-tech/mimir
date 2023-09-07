import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/card.dart';
import 'package:rettulf/rettulf.dart';
import "i18n.dart";

class ExpenseTrackerAppCard extends StatefulWidget {
  const ExpenseTrackerAppCard({super.key});

  @override
  State<ExpenseTrackerAppCard> createState() => _ExpenseTrackerAppCardState();
}

class _ExpenseTrackerAppCardState extends State<ExpenseTrackerAppCard> {
  @override
  Widget build(BuildContext context) {
    return FilledCard(
      child: [
        SizedBox(height: 120),
        ListTile(
          titleTextStyle: context.textTheme.titleLarge,
          title: i18n.title.text(),
        ),
        OverflowBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            FilledButton(onPressed: () async {
            }, child: "Check".text()),
          ],
        ).padOnly(l: 16, b: 12, r: 16),
      ].column(),
    );
  }
}
