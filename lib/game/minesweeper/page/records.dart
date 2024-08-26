import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/design/adaptive/menu.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/game/entity/game_result.dart';
import 'package:mimir/game/minesweeper/entity/record.dart';
import 'package:mimir/game/minesweeper/storage.dart';
import 'package:mimir/game/page/records.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/qrcode/page/view.dart';

import '../qrcode/blueprint.dart';
import '../i18n.dart';

class RecordsMinesweeperPage extends ConsumerStatefulWidget {
  const RecordsMinesweeperPage({super.key});

  @override
  ConsumerState createState() => _RecordsMinesweeperPageState();
}

class _RecordsMinesweeperPageState extends ConsumerState<RecordsMinesweeperPage> {
  @override
  Widget build(BuildContext context) {
    return GameRecordsPage<RecordMinesweeper>(
      title: i18n.records.title,
      recordStorage: StorageMinesweeper.record,
      itemBuilder: (context, record) {
        return RecordMinesweeperTile(record: record);
      },
    );
  }
}

class RecordMinesweeperTile extends StatelessWidget {
  final RecordMinesweeper record;

  const RecordMinesweeperTile({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: Icon(
        record.result == GameResult.victory ? Icons.check : Icons.clear,
        color: record.result == GameResult.victory ? Colors.green : Colors.red,
      ),
      title: i18n.records
          .record(
            mode: record.mode,
            rows: record.rows,
            columns: record.columns,
            mines: record.mines,
          )
          .text(),
      trailing: buildMoreActions(context),
      subtitle: [
        context.formatYmdhmsNum(record.ts).text(),
        i18n.formatPlaytime(record.playtime).text(),
        // record.blueprint.text(),
      ].column(caa: CrossAxisAlignment.start),
    );
  }

  Widget buildMoreActions(BuildContext context) {
    return PullDownMenuButton(
      itemBuilder: (ctx) => [
        PullDownItem(
            icon: context.icons.refresh,
            title: i18n.tryAgain,
            onTap: () async {
              await onHandleBlueprintMinesweeper(
                context: context,
                blueprint: record.blueprint,
              );
            }),
        PullDownItem(
          icon: context.icons.qrcode,
          title: i18n.shareQrCode,
          onTap: () {
            final qrCodeData = blueprintMinesweeperDeepLink.encodeString(
              record.blueprint,
            );
            context.showSheet(
              (context) => QrCodePage(
                title: i18n.title,
                data: qrCodeData.toString(),
              ),
            );
          },
        ),
      ],
    );
  }
}
