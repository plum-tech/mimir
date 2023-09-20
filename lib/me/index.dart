import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/adaptive/dialog.dart';
import 'package:mimir/entity/campus.dart';
import 'package:mimir/me/edu_email/index.dart';
import 'package:mimir/me/network_tool/index.dart';
import 'package:mimir/me/widgets/greeting.dart';
import 'package:mimir/settings/settings.dart';
import 'package:rettulf/rettulf.dart';
import 'package:url_launcher/url_launcher_string.dart';
import "i18n.dart";

const _qGroupNumber = "917740212";
const _joinQGroupUri =
    "mqqapi://card/show_pslcard?src_type=internal&version=1&uin=$_qGroupNumber&card_type=group&source=qrcode";

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
          titleTextStyle: context.textTheme.headlineSmall,
          title: const CampusSelector(),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.push("/settings");
              },
            ),
          ],
        ),
        const SliverToBoxAdapter(
          child: Greeting(),
        ),
        const SliverToBoxAdapter(
          child: EduEmailAppCard(),
        ),
        const SliverToBoxAdapter(
          child: NetworkToolAppCard(),
        ),
        SliverToBoxAdapter(
          child: buildGroupInvitation(),
        ),
      ],
    );
  }

  Widget buildGroupInvitation() {
    return ListTile(
      title: "预览版 QQ交流群".text(),
      subtitle: _qGroupNumber.text(),
      trailing: [
        IconButton(
          onPressed: () async {
            try {
              await launchUrlString(_joinQGroupUri);
            } catch (_) {}
          },
          icon: const Icon(Icons.group),
        ),
        IconButton(
          onPressed: () async {
            await Clipboard.setData(const ClipboardData(text: _qGroupNumber));
            if (!mounted) return;
            context.showSnackBar("已复制到剪贴板".text());
          },
          icon: const Icon(Icons.copy),
        ),
      ].row(mas: MainAxisSize.min),
      onTap: () async {
        try {
          await launchUrlString(_joinQGroupUri);
        } catch (_) {}
      },
    );
  }
}

class CampusSelector extends StatelessWidget {
  const CampusSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (ctx, setState) => SegmentedButton<Campus>(
        segments: Campus.values
            .map((e) => ButtonSegment<Campus>(
                  icon: const Icon(Icons.place_outlined),
                  value: e,
                  label: e.l10nName().text(),
                ))
            .toList(),
        selected: <Campus>{Settings.campus},
        onSelectionChanged: (newSelection) {
          setState(() {
            Settings.campus = newSelection.first;
          });
        },
      ),
    );
  }
}
