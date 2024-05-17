import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/menu.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/game/entity/game_result.dart';
import 'package:sit/game/i18n.dart';
import 'package:sit/game/page/records.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/qrcode/page/view.dart';

import '../qrcode/blueprint.dart';
import '../storage.dart';
import '../entity/record.dart';

class RecordsSudokuPage extends ConsumerStatefulWidget {
  const RecordsSudokuPage({super.key});

  @override
  ConsumerState createState() => _RecordsMinesweeperPageState();
}

class _RecordsMinesweeperPageState extends ConsumerState<RecordsSudokuPage> {
  @override
  Widget build(BuildContext context) {
    return GameRecordsPage<RecordSudoku>(
      title: 'Sudoku records',
      recordStorage: StorageSudoku.record,
      itemBuilder: (context, record) {
        return RecordSudokuTile(record: record);
      },
    );
  }
}

class RecordSudokuTile extends StatelessWidget {
  final RecordSudoku record;

  const RecordSudokuTile({
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
      title: "${record.mode.l10n()} with ${record.blanks} blanks".text(),
      trailing: buildMoreActions(context),
      subtitle: [
        context.formatYmdhmsNum(record.ts).text(),
        record.playTime.formatPlaytime().text(),
        // record.blueprint.text(),
      ].column(caa: CrossAxisAlignment.start),
    );
  }

  Widget buildMoreActions(BuildContext context) {
    return PullDownMenuButton(
      itemBuilder: (ctx) => [
        PullDownItem(
            icon: context.icons.refresh,
            title: "Play again",
            onTap: () async {
              await onHandleBlueprintSudoku(
                context: context,
                blueprint: record.blueprint,
              );
            }),
        PullDownItem(
          icon: context.icons.qrcode,
          title: "Share QR code",
          onTap: () {
            final qrCodeData = blueprintSudokuDeepLink.encodeString(
              record.blueprint,
            );
            context.showSheet(
              (context) => QrCodePage(
                title: "Sudoku".text(),
                data: qrCodeData.toString(),
              ),
            );
          },
        ),
      ],
    );
  }
}
