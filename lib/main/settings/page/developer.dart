import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mimir/global/init.dart';
import 'package:mimir/storage/page/editor.dart';
import 'package:rettulf/rettulf.dart';
import '../i18n.dart';

class DeveloperPage extends StatefulWidget {
  const DeveloperPage({
    super.key,
  });

  @override
  State<DeveloperPage> createState() => _DeveloperPageState();
}

class _DeveloperPageState extends State<DeveloperPage> {
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
              title: i18n.developerOptions.text(),
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
    all.add((_) => buildLocalStorage());
    if (kDebugMode) {
      all.add((_) => buildReload());
    }
    return all;
  }

  Widget buildLocalStorage() {
    return ListTile(
      title: i18n.localStorage.title.text(),
      subtitle: i18n.localStorage.desc.text(),
      leading: const Icon(Icons.storage),
      trailing: const Icon(Icons.navigate_next_rounded),
      onTap: () {
        context.navigator.push(MaterialPageRoute(builder: (_) => const LocalStoragePage()));
      },
    );
  }

  Widget buildReload() {
    return ListTile(
      title: i18n.reload.title.text(),
      subtitle: i18n.reload.desc.text(),
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
