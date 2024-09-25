import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/settings/settings.dart';
import 'package:mimir/timetable/p13n/widget/wallpaper.dart';

import '../init.dart';
import '../p13n/widget/style.dart';
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
    if (selected == null) {
      // If no timetable selected, navigate to Mine page to select/import one.
      return const MyTimetableListPage();
    } else {
      return TimetableStyleProv(
        child: buildBoard(selected),
      );
    }
  }

  Widget buildBoard(TimetableEntity timetable) {
    final focusTimetable = ref.watch(Settings.timetable.$focusTimetable);
    if (focusTimetable) {
      final background = ref.watch(Settings.timetable.$backgroundImage);
      if (background != null && background.enabled) {
        return WithWallpaper(
          background: ref.watch(Settings.timetable.$backgroundImage),
          child: TimetableBoardPage(
            timetable: timetable,
          ),
        );
      }
    }
    return TimetableBoardPage(
      timetable: timetable,
    );
  }
}
