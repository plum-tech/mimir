import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/settings/settings.dart';
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
    final entries = buildEntries();
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
            delegate: SliverChildBuilderDelegate(
              childCount: entries.length,
              (ctx, index) {
                return entries[index](ctx);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<WidgetBuilder> buildEntries() {
    final all = <WidgetBuilder>[];
    all.add((_) => buildDevModeToggle());
    all.add((_) => buildLocalStorage());
    all.add((_) => buildReload());
    return all;
  }

  Widget buildDevModeToggle() {
    return ListTile(
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
    );
  }

  Widget buildLocalStorage() {
    return ListTile(
      title: i18n.dev.localStorageTitle.text(),
      subtitle: i18n.dev.localStorageDesc.text(),
      leading: const Icon(Icons.storage),
      trailing: const Icon(Icons.navigate_next_rounded),
      onTap: () {
        context.push("/settings/developer/local-storage");
      },
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
