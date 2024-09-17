import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/entity/campus.dart';
import 'package:mimir/school/freshman/init.dart';
import 'package:mimir/school/yellow_pages/widget/contact.dart';
import 'package:mimir/settings/dev.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/widget/app.dart';

import 'entity/info.dart';
import 'x.dart';
import "i18n.dart";

class FreshmanAppCard extends ConsumerStatefulWidget {
  const FreshmanAppCard({super.key});

  @override
  ConsumerState<FreshmanAppCard> createState() => _FreshmanAppCardState();
}

class _FreshmanAppCardState extends ConsumerState<FreshmanAppCard> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    XFreshman.fetchInfo();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final info = ref.watch(FreshmanInit.storage.$info);
    return AppCard(
      title: i18n.title.text(),
      view: info == null ? null : FreshmanInfoPreviewCard(info: info),
      leftActions: ref.watch(Dev.$on) == true
          ? [
              FilledButton.icon(
                onPressed: () async {
                  await XFreshman.fetchInfo(preferCache: false);
                },
                icon: Icon(context.icons.refresh),
                label: i18n.refresh.text(),
              ),
            ]
          : null,
    );
  }
}

class FreshmanInfoPreviewCard extends StatelessWidget {
  final FreshmanInfo info;

  const FreshmanInfoPreviewCard({
    super.key,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return [
      SegmentedButton<Campus>(
        segments: Campus.values
            .map((e) => ButtonSegment<Campus>(
                  icon: Icon(context.icons.location),
                  value: e,
                  enabled: info.campus == e,
                  label: e.l10n().text(),
                ))
            .toList(),
        selected: {info.campus},
        onSelectionChanged: (newSelection) async {},
      ),
      ListTile(
        title: "学号: ${info.studentId}".text(),
        subtitle: "班级: ${info.yearClass}".text(),
        trailing: IconButton.filledTonal(
          icon: Icon(context.icons.copy),
          onPressed: () async {
            context.showSnackBar(content: i18n.copyTipOf("学号").text());
            await Clipboard.setData(ClipboardData(text: info.studentId));
          },
        ),
      ),
      ListTile(
        title: info.major.text(),
        subtitle: info.college.text(),
        trailing: IconButton.filledTonal(
          icon: Icon(context.icons.copy),
          onPressed: () async {
            context.showSnackBar(content: i18n.copyTipOf("专业").text());
            await Clipboard.setData(ClipboardData(text: info.studentId));
          },
        ),
      ),
      ListTile(
        title: "${info.buildingNumber}号楼 ${info.roomNumber}".text(),
        subtitle: "${info.bedNumber}床位".text(),
      ),
      ContactTile(
        title: "辅导员",
        name: info.counselorName,
        phone: info.counselorContact,
      ),
      if (info.counselorNote.isNotEmpty)
        ListTile(
          title: "辅导员备注".text(),
          subtitle: info.counselorNote.text(),
        ),
    ].column().inCard();
  }
}
