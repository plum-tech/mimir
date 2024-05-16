import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/adaptive/swipe.dart';
import 'package:sit/game/entity/record.dart';
import 'package:sit/game/storage/record.dart';

class GameRecordsPage<TRecord extends GameRecord> extends ConsumerStatefulWidget {
  final String title;
  final GameRecordStorage<TRecord> recordStorage;
  final Widget Function(BuildContext context, TRecord record) itemBuilder;

  const GameRecordsPage({
    super.key,
    required this.title,
    required this.recordStorage,
    required this.itemBuilder,
  });

  @override
  ConsumerState<GameRecordsPage<TRecord>> createState() => _RecordsMinesweeperPageState<TRecord>();
}

class _RecordsMinesweeperPageState<TRecord extends GameRecord> extends ConsumerState<GameRecordsPage<TRecord>> {
  @override
  Widget build(BuildContext context) {
    final rows = ref.watch(widget.recordStorage.table.$rows).reversed.toList();
    return Scaffold(
      appBar: AppBar(
        title: widget.title.text(),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList.builder(
            itemCount: rows.length,
            itemBuilder: (ctx, i) {
              final row = rows[i];
              return WithSwipeAction(
                childKey: ValueKey(row.id),
                right: SwipeAction.delete(
                  icon: ctx.icons.delete,
                  action: () {
                    widget.recordStorage.table.delete(row.id);
                  },
                ),
                child: widget.itemBuilder(ctx, row.row),
              );
            },
          ),
        ],
      ),
    );
  }
}
