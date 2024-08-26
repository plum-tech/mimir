import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/game/page/records.dart';
import 'package:mimir/l10n/extension.dart';

import '../storage.dart';
import '../entity/record.dart';
import '../i18n.dart';

class Records2048Page extends ConsumerStatefulWidget {
  const Records2048Page({super.key});

  @override
  ConsumerState createState() => _RecordsMinesweeperPageState();
}

class _RecordsMinesweeperPageState extends ConsumerState<Records2048Page> {
  @override
  Widget build(BuildContext context) {
    return GameRecordsPage<Record2048>(
      title: i18n.records.title,
      recordStorage: Storage2048.record,
      itemBuilder: (context, record) {
        return Record2048Tile(record: record);
      },
    );
  }
}

class Record2048Tile extends StatelessWidget {
  final Record2048 record;

  const Record2048Tile({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: Icon(
        record.hasVictory ? Icons.check : Icons.clear,
        color: record.hasVictory ? Colors.green : Colors.red,
      ),
      title: i18n.records
          .record(
            maxNumber: record.maxNumber,
            score: record.score,
          )
          .text(),
      subtitle: [
        context.formatYmdhmsNum(record.ts).text(),
        // record.blueprint.text(),
      ].column(caa: CrossAxisAlignment.start),
    );
  }
}
