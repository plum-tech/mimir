import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../init.dart';
import '../widgets/style.dart';
import 'mine.dart';
import 'timetable.dart';
import '../entity/timetable_entity.dart';

class TimetablePage extends ConsumerStatefulWidget {
  const TimetablePage({super.key});

  @override
  ConsumerState<TimetablePage> createState() => _TimetablePageState();
}

final $selectedTimetableEntity = Provider.autoDispose((ref) {
  final timetable = ref.watch(TimetableInit.storage.timetable.$selectedRow);
  return timetable?.resolve();
});

class _TimetablePageState extends ConsumerState<TimetablePage> {
  @override
  Widget build(BuildContext context) {
    final selected = ref.watch($selectedTimetableEntity);
    final selectedId = ref.watch(TimetableInit.storage.timetable.$selectedId);
    if (selected == null || selectedId == null) {
      // If no timetable selected, navigate to Mine page to select/import one.
      return const MyTimetableListPage();
    } else {
      return TimetableStyleProv(
        child: TimetableBoardPage(
          id: selectedId,
          timetable: selected,
        ),
      );
    }
  }
}
