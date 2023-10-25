import 'package:flutter/material.dart';

import '../entity/timetable.dart';
import '../init.dart';
import '../widgets/style.dart';
import 'mine.dart';
import 'timetable.dart';

class TimetablePage extends StatefulWidget {
  const TimetablePage({super.key});

  @override
  State<TimetablePage> createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  late SitTimetableEntity? _selected;
  final $selected = TimetableInit.storage.timetable.$selected;

  @override
  void initState() {
    super.initState();
    _selected = TimetableInit.storage.timetable.selectedRow?.resolve();
    $selected.addListener(onSelectChange);
  }

  @override
  void dispose() {
    $selected.removeListener(onSelectChange);
    super.dispose();
  }

  void onSelectChange() {
    final current = TimetableInit.storage.timetable.selectedRow;
    if (!mounted) return;
    setState(() {
      _selected = current?.resolve();
    });
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
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
