import 'package:flutter/material.dart';

import '../entity/entity.dart';
import '../events.dart';
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
  late SitTimetable? _selected = () {
    final id = storage.currentTimetableId;
    return id == null ? null : storage.getSitTimetableBy(id: id);
  }();

  @override
  void initState() {
    super.initState();
    storage.onCurrentTimetableIdChanged.addListener(refresh);
  }

  @override
  void dispose() {
    storage.onCurrentTimetableIdChanged.removeListener(refresh);
    super.dispose();
  }

  void refresh() {
    final currentId = storage.currentTimetableId;
    if (currentId != null) {
      if (!mounted) return;
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
