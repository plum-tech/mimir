import 'package:flutter/material.dart';

import '../entity/entity.dart';
import '../entity/meta.dart';
import '../events.dart';
import '../init.dart';
import '../user_widget/style.dart';
import 'mine.dart';
import 'timetable.dart';

class TimetableIndexPage extends StatefulWidget {
  const TimetableIndexPage({super.key});

  @override
  State<TimetableIndexPage> createState() => _TimetableIndexPageState();
}

class _TimetableIndexPageState extends State<TimetableIndexPage> {
  final storage = TimetableInit.timetableStorage;

  SitTimetable? _selected;

  @override
  void initState() {
    super.initState();
    refresh();
    eventBus.on<CurrentTimetableChangeEvent>().listen((event) {
      refresh();
    });
  }

  void refresh() {
    if (!mounted) return;
    final currentId = storage.currentTimetableId;
    if (currentId != null) {
      setState(() {
        _selected = storage.getSitTimetableBy(id: currentId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _selected;
    if (selected == null) {
      // If no timetable selected, navigate to Mine page to select/import one.
      return const MyTimetablePage();
    } else {
      return TimetableStyleProv(
        child: TimetablePage(
          timetable: selected,
        ),
      );
    }
  }
}
