import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/life/expense_records/entity/statistics.dart';
import 'package:sit/life/expense_records/storage/local.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/life/expense_records/utils.dart';
import 'package:sit/utils/collection.dart';

import '../entity/local.dart';
import '../i18n.dart';
import '../init.dart';
import '../widget/chart/bar.dart';
import '../widget/chart/pie.dart';
import '../widget/transaction.dart';

class ExpenseStatisticsPage extends ConsumerStatefulWidget {
  const ExpenseStatisticsPage({super.key});

  @override
  ConsumerState<ExpenseStatisticsPage> createState() => _ExpenseStatisticsPageState();
}

typedef Type2transactions = Map<TransactionType, ({List<Transaction> records, double total, double proportion})>;

final _allRecords = Provider.autoDispose((ref) {
  final all = ExpenseRecordsInit.storage.getTransactionsByRange() ?? const [];
  all.retainWhere((record) => record.type.isConsume);
  return all;
});

final _statisticsMode =
    NotifierProvider.autoDispose<_StatisticsModeNotifier, StatisticsMode>(_StatisticsModeNotifier.new);

class _StatisticsModeNotifier extends AutoDisposeNotifier<StatisticsMode> {
  @override
  StatisticsMode build() => StatisticsMode.month;

  void set(StatisticsMode mode) {
    state = mode;
  }
}

final _startTime2Records = Provider.autoDispose((ref) {
  final mode = ref.watch(_statisticsMode);
  final all = ref.watch(_allRecords);
  return mode.resort(all);
});

class _ExpenseStatisticsPageState extends ConsumerState<ExpenseStatisticsPage> {
  late int index = ref.read(_startTime2Records).length - 1;
  final controller = ScrollController();
  final $showTimeSpan = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      final pos = controller.positions.last;
      final showTimeSpan = $showTimeSpan.value;
      if (pos.pixels > pos.minScrollExtent) {
        if (!showTimeSpan) {
          setState(() {
            $showTimeSpan.value = true;
          });
        }
      } else {
        if (showTimeSpan) {
          setState(() {
            $showTimeSpan.value = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(_statisticsMode);
    final startTime2Records = ref.watch(_startTime2Records);
    ref.listen(_startTime2Records, (previous, next) {
      setState(() {
        index = next.length - 1;
      });
    });
    final current = startTime2Records.indexAt(index);
    return Scaffold(
      appBar: AppBar(
        title: i18n.stats.title.text(),
      ),
      body: [
        ListView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            buildModeSelector(mode).padSymmetric(h: 16, v: 4),
            ExpenseBarChart(
              start: current.start,
              records: current.records,
              mode: mode,
            ),
            const Divider(),
            ExpensePieChart(records: current.records),
            const Divider(),
            ...current.records.map((record) {
              return TransactionTile(record);
            }),
          ],
        ),
        // ListView()
        $showTimeSpan >>
            (ctx, showTimeSpan) => AnimatedSlide(
                  offset: showTimeSpan ? Offset.zero : const Offset(0, -2),
                  duration: Durations.long4,
                  child: AnimatedSwitcher(
                    duration: Durations.long4,
                    child: showTimeSpan ? buildHeader(current.start) : null,
                  ),
                ).align(at: Alignment.topCenter),
      ].stack(),
    );
  }

  Widget buildModeSelector(StatisticsMode selected) {
    return SegmentedButton<StatisticsMode>(
      showSelectedIcon: false,
      segments: StatisticsMode.values
          .map((e) => ButtonSegment<StatisticsMode>(
                value: e,
                label: e.l10nName().text(),
              ))
          .toList(),
      selected: <StatisticsMode>{selected},
      onSelectionChanged: (newSelection) {
        ref.read(_statisticsMode.notifier).set(newSelection.first);
      },
    );
  }

  Widget buildHeader(DateTime start) {
    final startTime2Records = ref.watch(_startTime2Records);
    final mode = ref.watch(_statisticsMode);
    return FilledCard(
      child: [
        PlatformIconButton(
          onPressed: index > 0
              ? () {
                  setState(() {
                    index = index - 1;
                  });
                }
              : null,
          icon: Icon(context.icons.leftChevron),
        ),
        resolveTime4Display(context: context, mode: mode, date: start).text(),
        PlatformIconButton(
          onPressed: index < startTime2Records.length - 1
              ? () {
                  setState(() {
                    index = index + 1;
                  });
                }
              : null,
          icon: Icon(context.icons.rightChevron),
        ),
      ].row(maa: MainAxisAlignment.spaceBetween),
    );
  }
}
