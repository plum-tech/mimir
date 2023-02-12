import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mimir/module/activity/using.dart';
import 'package:rettulf/rettulf.dart';

import '../widgets/box.dart';

class LocalStoragePage extends StatefulWidget {
  const LocalStoragePage({super.key});

  @override
  State<LocalStoragePage> createState() => _LocalStoragePageState();
}

class _LocalStoragePageState extends State<LocalStoragePage> {
  final Map<String, Future<Box<dynamic>>> name2Box = {};

  @override
  void initState() {
    super.initState();
    refreshBoxes();
  }

  @override
  Widget build(BuildContext context) {
    return context.isPortrait ? StorageList(name2Box) : StorageBox(name2Box);
  }

  void refreshBoxes() {
    name2Box.clear();
    for (final entry in HiveBoxInit.name2Box.entries) {
      final boxName = entry.key;
      final box = entry.value;
      if (box.isOpen) {
        name2Box[boxName] = Future(() => box);
      }
    }
  }
}

class StorageList extends StatefulWidget {
  final Map<String, Future<Box<dynamic>>> name2box;

  const StorageList(this.name2box, {super.key});

  @override
  State<StorageList> createState() => _StorageListState();
}

class _StorageListState extends State<StorageList> {
  final List<MapEntry<String, Future<Box<dynamic>>>> opened = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: i18n.localStorageTitle.text()),
      body: buildBody(ctx).scrolledWithBar(),
    );
  }

  Widget buildBody(BuildContext context) {
    return widget.name2box.entries
        .mapIndexed((i, p) => PlaceholderFutureBuilder<Box<dynamic>>(
            future: p.value.withDelay(Duration(milliseconds: 200 * i)),
            builder: (ctx, box, _) {
              return BoxSection(box: box, boxName: p.key);
            }))
        .toList()
        .column();
  }
}
