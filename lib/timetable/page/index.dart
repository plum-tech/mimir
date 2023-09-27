import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/timetable/storage/timetable.dart';

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
  TimetableStorage get storage => TimetableInit.storage;
  late SitTimetable? _selected = storage.timetable.selectedRow;
  final $selected = TimetableInit.storage.timetable.$selected;
  @override
  void initState() {
    super.initState();
    $selected.addListener(refresh);
  }

  @override
  void dispose() {
    $selected.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    final current = storage.timetable.selectedRow;
    if (!mounted) return;
    setState(() {
      _selected = current;
    });
    if (!storage.timetable.hasAny) {
      // if no timetables, go out.
      context.pop();
    }
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
