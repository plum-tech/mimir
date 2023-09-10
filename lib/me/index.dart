import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/widgets/dialog.dart';
import 'package:mimir/me/edu_email/index.dart';
import 'package:mimir/me/network_tool/index.dart';
import 'package:rettulf/rettulf.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          const SliverToBoxAdapter(
            child: EduEmailAppCard(),
          ),
          const SliverToBoxAdapter(
            child: NetworkToolAppCard(),
          ),
          ListTile(
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
          )
        ]))
      ],
    );
  }
}
