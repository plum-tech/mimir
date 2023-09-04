import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../entity/entity.dart';
import '../init.dart';
import '../widgets/style.dart';
import 'mine.dart';
import 'timetable.dart';

class TimetableIndexPage extends StatefulWidget {
  const TimetableIndexPage({super.key});

  @override
  State<TimetableIndexPage> createState() => _TimetableIndexPageState();
}

class _TimetableIndexPageState extends State<TimetableIndexPage> {
  final storage = TimetableInit.storage;
  late SitTimetable? _selected = storage.getSitTimetableById(id: storage.currentTimetableId);

  @override
  void initState() {
    super.initState();
    storage.onCurrentTimetableChanged.addListener(refresh);
  }

  @override
  void dispose() {
    storage.onCurrentTimetableChanged.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    final current = storage.getSitTimetableById(id: storage.currentTimetableId);
    if (!mounted) return;
    setState(() {
      _selected = current;
    });
    if (storage.timetableIds.isEmpty) {
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
        child: TimetablePage(
          timetable: selected,
        ),
      );
    }
  }
}
