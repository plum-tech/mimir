import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/app.dart';
import 'package:rettulf/rettulf.dart';
import "i18n.dart";

class NetworkToolAppCard extends StatefulWidget {
  const NetworkToolAppCard({super.key});

  @override
  State<NetworkToolAppCard> createState() => _NetworkToolAppCardState();
}

class _NetworkToolAppCardState extends State<NetworkToolAppCard> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: i18n.title.text(),
    );
  }
}
