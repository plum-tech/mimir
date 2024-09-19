import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/design/adaptive/menu.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:mimir/game/entity/game_result.dart';
import 'package:mimir/game/page/records.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/intent/qrcode/page/view.dart';

import '../qrcode/blueprint.dart';
import '../storage.dart';
import '../entity/record.dart';
import '../i18n.dart';

class RecordsSudokuPage extends ConsumerStatefulWidget {
  const RecordsSudokuPage({super.key});

  @override
  ConsumerState createState() => _RecordsSudokuPageState();
}

class _RecordsSudokuPageState extends ConsumerState<RecordsSudokuPage> {
  @override
  Widget build(BuildContext context) {
    return GameRecordsPage<RecordSudoku>(
      title: i18n.records.title,
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
      leading: Icon(
        record.result == GameResult.victory ? Icons.check : Icons.clear,
        color: record.result == GameResult.victory ? Colors.green : Colors.red,
      ),
      title: i18n.records
          .record(
            mode: record.mode,
            blanks: record.blanks,
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
              await onHandleBlueprintSudoku(
                context: context,
                blueprint: record.blueprint,
              );
            }),
        PullDownItem(
          icon: context.icons.qrcode,
          title: i18n.shareQrCode,
          onTap: () {
            final qrCodeData = blueprintSudokuDeepLink.encodeString(
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
