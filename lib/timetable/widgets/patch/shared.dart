import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/timetable/entity/pos.dart';

import '../../entity/loc.dart';
import '../../entity/timetable.dart';
import '../../i18n.dart';
import '../../utils.dart';

class TimetableDayLocModeSwitcher extends StatelessWidget {
  final TimetableDayLocMode selected;
  final ValueChanged<TimetableDayLocMode> onSelected;

  const TimetableDayLocModeSwitcher({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TimetableDayLocMode>(
      segments: TimetableDayLocMode.values
          .map((e) => ButtonSegment<TimetableDayLocMode>(
                value: e,
                label: e.l10n().text(),
              ))
          .toList(),
      selected: <TimetableDayLocMode>{selected},
      onSelectionChanged: (newSelection) async {
        onSelected(newSelection.first);
      },
    );
  }
}

final _lastInitialDate = StateProvider<DateTime>((ref) => DateTime.now());

class TimetableDayLocPosSelectionTile extends StatelessWidget {
  final Widget title;
  final Widget? leading;
  final TimetablePos? pos;
  final SitTimetable timetable;
  final ValueChanged<TimetablePos> onChanged;

  const TimetableDayLocPosSelectionTile({
    super.key,
    required this.title,
    this.leading,
    this.pos,
    required this.onChanged,
    required this.timetable,
  });

  @override
  Widget build(BuildContext context) {
    final pos = this.pos;
    return ListTile(
      leading: leading,
      title: title,
      subtitle: pos == null ? i18n.unspecified.text() : pos.l10n().text(),
      trailing: FilledButton(
        child: i18n.select.text(),
        onPressed: () async {
          final newPos = await selectDayInTimetable(
            context: context,
            timetable: timetable,
            initialPos: pos,
            submitLabel: i18n.select,
          );
          if (newPos == null) return;
          onChanged(newPos);
        },
      ),
    );
  }
}

class TimetableDayLocDateSelectionTile extends ConsumerWidget {
  final Widget title;
  final Widget? leading;
  final DateTime? date;
  final SitTimetable timetable;
  final ValueChanged<DateTime> onChanged;

  const TimetableDayLocDateSelectionTile({
    super.key,
    this.leading,
    required this.title,
    this.date,
    required this.onChanged,
    required this.timetable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = this.date;
    return ListTile(
      leading: leading,
      title: title,
      subtitle: date == null ? i18n.unspecified.text() : context.formatYmdWeekText(date).text(),
      trailing: FilledButton(
        child: i18n.select.text(),
        onPressed: () async {
          final now = DateTime.now();
          final newDate = await showDatePicker(
            context: context,
            initialDate: date ?? ref.read(_lastInitialDate),
            currentDate: date,
            firstDate: DateTime(now.year - 4),
            lastDate: DateTime(now.year + 2),
          );
          if (newDate == null) return;
          ref.read(_lastInitialDate.notifier).state = newDate;
          onChanged(newDate);
        },
      ),
    );
  }
}
