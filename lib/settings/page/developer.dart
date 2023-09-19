import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/settings/widgets/navigation.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

class DeveloperOptionsPage extends StatefulWidget {
  const DeveloperOptionsPage({
    super.key,
  });

  @override
  State<DeveloperOptionsPage> createState() => _DeveloperOptionsPageState();
}

class _DeveloperOptionsPageState extends State<DeveloperOptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const RangeMaintainingScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            snap: false,
            floating: false,
            expandedHeight: 100.0,
            flexibleSpace: FlexibleSpaceBar(
              title: i18n.dev.title.text(style: context.textTheme.headlineSmall),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              buildDevModeToggle(),
              PageNavigationTile(
                title: i18n.dev.localStorageTitle.text(),
                subtitle: i18n.dev.localStorageDesc.text(),
                icon: const Icon(Icons.storage),
                path: "/settings/developer/local-storage",
              ),
              buildReload(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget buildDevModeToggle() {
    return StatefulBuilder(
      builder: (ctx, setState) => ListTile(
        title: i18n.dev.devMode.text(),
        leading: const Icon(Icons.developer_mode_outlined),
        trailing: Switch.adaptive(
          value: Settings.isDeveloperMode,
          onChanged: (newV) {
            setState(() {
              Settings.isDeveloperMode = newV;
            });
          },
        ),
      ),
    );
  }

  Widget buildReload() {
    return ListTile(
      title: i18n.dev.reloadTitle.text(),
      subtitle: i18n.dev.reloadDesc.text(),
      leading: const Icon(Icons.refresh_rounded),
      onTap: () async {
        await Init.init();
        final engine = WidgetsFlutterBinding.ensureInitialized();
        engine.performReassemble();
        if (!mounted) return;
        context.navigator.pop();
      },
    );
  }
}
