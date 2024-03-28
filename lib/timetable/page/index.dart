import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../init.dart';
import '../widgets/style.dart';
import 'mine.dart';
import 'timetable.dart';

class TimetablePage extends ConsumerStatefulWidget {
  const TimetablePage({super.key});

  @override
  ConsumerState<TimetablePage> createState() => _TimetablePageState();
}

final selectedTimetableEntityProvider = Provider.autoDispose((ref) {
  final timetable = ref.watch(TimetableInit.storage.timetable.selectedRowProvider);
  return timetable?.resolve();
});

class _TimetablePageState extends ConsumerState<TimetablePage> {
  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(selectedTimetableEntityProvider);
    if (selected == null) {
      // If no timetable selected, navigate to Mine page to select/import one.
      return const MyTimetableListPage();
    } else {
      return TimetableStyleProv(
        child: TimetableBoardPage(
          timetable: selected,
        ),
      );
    }
  }
}
