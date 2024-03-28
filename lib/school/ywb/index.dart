import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/app.dart';
import 'package:sit/school/ywb/entity/application.dart';
import 'package:sit/school/ywb/init.dart';
import 'package:rettulf/rettulf.dart';

import "i18n.dart";
import 'widgets/application.dart';

const _applicationLength = 2;

class YwbAppCard extends ConsumerStatefulWidget {
  const YwbAppCard({super.key});

  @override
  ConsumerState<YwbAppCard> createState() => _YwbAppCardState();
}

class _YwbAppCardState extends ConsumerState<YwbAppCard> {
  @override
  Widget build(BuildContext context) {
    final storage = YwbInit.applicationStorage;
    final running = ref.watch(storage.$applicationFamily(YwbApplicationType.running));
    return AppCard(
      title: i18n.title.text(),
      view: running == null ? null : buildRunningCard(running),
      leftActions: [
        FilledButton.icon(
          onPressed: () {
            context.push("/ywb");
          },
          icon: const Icon(Icons.list_alt),
          label: i18n.seeAll.text(),
        ),
        OutlinedButton.icon(
          onPressed: () {
            context.push("/ywb/mine");
          },
          label: i18n.action.applications.text(),
          icon: Icon(context.icons.mail),
        )
      ],
    );
  }

  Widget buildRunningCard(List<YwbApplication> running) {
    final applications = running.sublist(0, min(_applicationLength, running.length));
    return applications
        .map((e) => YwbApplicationTile(e).inCard(
              clip: Clip.hardEdge,
            ))
        .toList()
        .column();
  }
}
