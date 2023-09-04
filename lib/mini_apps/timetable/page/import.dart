import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/mini_apps/timetable/storage/timetable.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/entity.dart';
import '../entity/meta.dart';
import '../init.dart';
import '../widgets/meta_editor.dart';
import '../using.dart';

enum ImportStatus {
  none,
  importing,
  end,
  failed;
}

class ImportTimetablePage extends StatefulWidget {
  const ImportTimetablePage({super.key});

  @override
  State<ImportTimetablePage> createState() => _ImportTimetablePageState();
}

class _ImportTimetablePageState extends State<ImportTimetablePage> {
  bool canImport = false;
  final service = TimetableInit.service;
  final storage = TimetableInit.storage;
  var _status = ImportStatus.none;
  late int selectedYear;
  late Semester selectedSemester;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    // Estimate current school year and semester.
    selectedYear = now.month >= 9 ? now.year : now.year - 1;
    selectedSemester = now.month >= 3 && now.month <= 7 ? Semester.term2 : Semester.term1;
  }

  String getTip({required ImportStatus by}) {
    switch (by) {
      case ImportStatus.none:
        return i18n.import.selectSemesterTip;
      case ImportStatus.importing:
        return i18n.import.importing;
      case ImportStatus.end:
        return i18n.import.endTip;
      default:
        return i18n.import.failedTip;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isImporting = _status == ImportStatus.importing;
    return Scaffold(
      appBar: AppBar(
        title: i18n.import.title.text(),
        bottom: !isImporting
            ? null
            : const PreferredSize(
                preferredSize: Size.fromHeight(4),
                child: LinearProgressIndicator(),
              ),
      ),
      body: (canImport
              ? buildImportPage(key: const ValueKey("Import Timetable"))
              : buildConnectivityChecker(context, const ValueKey("Connectivity Checker")))
          .animatedSwitched(),
    );
  }

  Widget buildConnectivityChecker(BuildContext ctx, Key? key) {
    return ConnectivityChecker(
      key: key,
      iconSize: ctx.isPortrait ? 180 : 120,
      initialDesc: i18n.import.connectivityCheckerDesc,
      check: TimetableInit.network.checkConnectivity,
      onConnected: () {
        if (!mounted) return;
        setState(() {
          canImport = true;
        });
      },
    );
  }

  Widget buildTip(BuildContext ctx) {
    final tip = getTip(by: _status);
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.fastLinearToSlowEaseIn,
        switchOutCurve: Curves.fastLinearToSlowEaseIn,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Text(
          key: ValueKey(_status),
          tip,
          style: ctx.textTheme.titleLarge,
        ));
  }

  Widget buildImportPage({Key? key}) {
    return Column(
      key: key,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 30), child: buildTip(context)),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: SemesterSelector(
              onNewYearSelect: (year) {
                setState(() => selectedYear = year);
              },
              onNewSemesterSelect: (semester) {
                setState(() => selectedSemester = semester);
              },
              initialYear: selectedYear,
              initialSemester: selectedSemester,
              showEntireYear: false,
              showNextYear: true,
            )),
        Padding(
          padding: const EdgeInsets.all(24),
          child: buildImportButton(context),
        )
      ],
    );
  }

  Future<SitTimetable?> handleTimetableData(
      BuildContext ctx, SitTimetable timetable, int year, Semester semester) async {
    final defaultName = i18n.import.defaultName(semester.localized(), year.toString(), (year + 1).toString());
    DateTime defaultStartDate;
    if (semester == Semester.term1) {
      defaultStartDate = findFirstWeekdayInCurrentMonth(DateTime(year, 9), DateTime.monday);
    } else {
      defaultStartDate = findFirstWeekdayInCurrentMonth(DateTime(year + 1, 2), DateTime.monday);
    }
    final meta = TimetableMeta(
      name: defaultName,
      semester: semester,
      startDate: defaultStartDate,
      schoolYear: year,
    );
    final newMeta = await ctx.showSheet<TimetableMeta>(
      (ctx) => MetaEditor(meta: meta).padOnly(b: MediaQuery.of(ctx).viewInsets.bottom),
      dismissible: false,
    );
    if (newMeta != null) {
      final newTimetable = timetable.copyWithMeta(newMeta);
      storage.addTimetable(newTimetable);
      return newTimetable;
    }
    return null;
  }

  Widget buildImportButton(BuildContext ctx) {
    return ElevatedButton(
      onPressed: _status == ImportStatus.importing
          ? null
          : () async {
              setState(() {
                _status = ImportStatus.importing;
              });
              try {
                final semester = selectedSemester;
                final year = SchoolYear(selectedYear);
                await Future.wait([
                  service.getTimetable(year, semester),
                  //fetchMockCourses(),
                  Future.delayed(const Duration(seconds: 1)),
                ]).then((value) async {
                  if (!mounted) return;
                  setState(() {
                    _status = ImportStatus.end;
                  });
                  final timetable = await handleTimetableData(ctx, value[0] as SitTimetable, selectedYear, semester);
                  if (!mounted) return;
                  context.pop(timetable);
                }).onError((error, stackTrace) {
                  Log.error(error);
                  Log.error(stackTrace);
                });
              } catch (e) {
                setState(() {
                  _status = ImportStatus.failed;
                });
                if (!mounted) return;
                await context.showTip(title: i18n.import.failed, desc: i18n.import.failedDesc, ok: i18n.ok);
              } finally {
                if (_status == ImportStatus.importing) {
                  setState(() {
                    _status = ImportStatus.end;
                  });
                }
              }
            },
      child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            i18n.import.button,
            style: TextStyle(fontSize: ctx.textTheme.titleLarge?.fontSize),
          )),
    );
  }
}

DateTime findFirstWeekdayInCurrentMonth(DateTime current, int weekday) {
  // Calculate the first day of the current month while keeping the same year.
  DateTime firstDayOfMonth = DateTime(current.year, current.month, 1);

  // Calculate the difference in days between the first day of the current month
  // and the desired weekday.
  int daysUntilWeekday = (weekday - firstDayOfMonth.weekday + 7) % 7;

  // Calculate the date of the first occurrence of the desired weekday in the current month.
  DateTime firstWeekdayInMonth = firstDayOfMonth.add(Duration(days: daysUntilWeekday));

  return firstWeekdayInMonth;
}
