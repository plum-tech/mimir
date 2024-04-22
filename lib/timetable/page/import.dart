import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sit/credentials/entity/user_type.dart';
import 'package:sit/credentials/init.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/animation/animated.dart';
import 'package:sit/network/widgets/checker.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/school/entity/school.dart';
import 'package:sit/school/utils.dart';
import 'package:sit/school/widgets/semester.dart';
import 'package:sit/settings/settings.dart';
import 'package:sit/timetable/utils.dart';
import 'package:rettulf/rettulf.dart';

import '../i18n.dart';
import '../entity/timetable.dart';
import '../init.dart';
import 'editor.dart';

enum ImportStatus {
  none,
  importing,
  end,
  failed;
}

class ImportTimetablePage extends ConsumerStatefulWidget {
  const ImportTimetablePage({super.key});

  @override
  ConsumerState<ImportTimetablePage> createState() => _ImportTimetablePageState();
}

class _ImportTimetablePageState extends ConsumerState<ImportTimetablePage> {
  bool canImport = false;
  var _status = ImportStatus.none;
  late SemesterInfo initial = estimateCurrentSemester();
  late SemesterInfo selected = initial;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isImporting = _status == ImportStatus.importing;
    return Scaffold(
      appBar: AppBar(
        title: i18n.import.title.text(),
        actions: [
          PlatformTextButton(onPressed: importFromFile, child: i18n.import.fromFileBtn.text()),
        ],
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

  Future<void> importFromFile() async {
    final timetable = await readTimetableFromPickedFileWithPrompt(context);
    if (timetable == null) return;
    final id = TimetableInit.storage.timetable.add(timetable);
    if (!mounted) return;
    context.pop((id: id, timetable: timetable));
  }

  Widget buildConnectivityChecker(BuildContext ctx, Key? key) {
    return ConnectivityChecker(
      key: key,
      iconSize: ctx.isPortrait ? 180 : 120,
      initialDesc: i18n.import.connectivityCheckerDesc,
      check: TimetableInit.service.checkConnectivity,
      onConnected: () {
        if (!mounted) return;
        setState(() {
          canImport = true;
        });
      },
    );
  }

  Widget buildTip(BuildContext ctx) {
    final tip = switch (_status) {
      ImportStatus.none => i18n.import.selectSemesterTip,
      ImportStatus.importing => i18n.import.importing,
      ImportStatus.end => i18n.import.endTip,
      ImportStatus.failed => i18n.import.failedTip,
    };
    return tip
        .text(
          key: ValueKey(_status),
          style: ctx.textTheme.titleLarge,
        )
        .animatedSwitched();
  }

  Widget buildImportPage({Key? key}) {
    final credentials = ref.watch(CredentialsInit.storage.$oaCredentials);
    return [
      buildTip(context).padSymmetric(v: 30),
      SemesterSelector(
        baseYear: getAdmissionYearFromStudentId(credentials?.account),
        initial: initial,
        onSelected: (newSelection) {
          setState(() {
            selected = newSelection;
          });
        },
      ).padSymmetric(v: 30),
      buildImportButton(context).padAll(24),
    ].column(key: key, maa: MainAxisAlignment.center, caa: CrossAxisAlignment.center);
  }

  Future<({int id, SitTimetable timetable})?> handleTimetableData(
    SitTimetable timetable,
    SemesterInfo info,
  ) async {
    final SemesterInfo(:exactYear, :semester) = info;
    final defaultName = i18n.import.defaultName(semester.l10n(), exactYear.toString(), (exactYear + 1).toString());
    DateTime defaultStartDate = estimateStartDate(exactYear, semester);
    final userType = ref.read(CredentialsInit.storage.$oaUserType);
    if (userType == OaUserType.undergraduate) {
      final current = estimateCurrentSemester();
      if (info == current) {
        final span = await TimetableInit.service.getUgSemesterSpan();
        if (span != null) {
          defaultStartDate = span.start;
        }
      }
    }
    if (!mounted) return null;
    final newTimetable = await context.show$Sheet$<SitTimetable>(
      (ctx) => TimetableEditorPage(
        timetable: timetable.copyWith(
          name: defaultName,
          semester: semester,
          startDate: defaultStartDate,
          schoolYear: exactYear,
          signature: Settings.lastSignature,
        ),
      ),
      dismissible: false,
    );
    if (newTimetable != null) {
      final id = TimetableInit.storage.timetable.add(newTimetable);
      return (id: id, timetable: timetable);
    }
    return null;
  }

  DateTime estimateStartDate(int year, Semester semester) {
    if (semester == Semester.term1) {
      return findFirstWeekdayInCurrentMonth(DateTime(year, 9), DateTime.monday);
    } else {
      return findFirstWeekdayInCurrentMonth(DateTime(year + 1, 2), DateTime.monday);
    }
  }

  Widget buildImportButton(BuildContext ctx) {
    return PlatformElevatedButton(
      onPressed: _status == ImportStatus.importing ? null : _onImport,
      child: i18n.import.tryImportBtn.text(),
    );
  }

  Future<SitTimetable> getTimetable(SemesterInfo info) async {
    final userType = ref.read(CredentialsInit.storage.$oaUserType);
    return switch (userType) {
      OaUserType.undergraduate => TimetableInit.service.fetchUgTimetable(info),
      OaUserType.postgraduate => TimetableInit.service.fetchPgTimetable(info),
      OaUserType.other => throw Exception("Timetable importing not supported"),
      _ => throw Exception("Timetable importing not supported"),
    };
  }

  void _onImport() async {
    setState(() {
      _status = ImportStatus.importing;
    });
    try {
      final selected = this.selected;
      final timetable = await getTimetable(selected);
      if (!mounted) return;
      setState(() {
        _status = ImportStatus.end;
      });
      final id2timetable = await handleTimetableData(timetable, selected);
      if (id2timetable == null) return;
      if (!mounted) return;
      context.pop(id2timetable);
    } catch (e, stackTrace) {
      if (e is ParallelWaitError) {
        final inner = e.errors.$1 as AsyncError;
        debugPrint(inner.toString());
        debugPrintStack(stackTrace: inner.stackTrace);
      } else {
        debugPrint(e.toString());
        debugPrintStack(stackTrace: stackTrace);
      }
      setState(() {
        _status = ImportStatus.failed;
      });
      if (!mounted) return;
      await context.showTip(title: i18n.import.failed, desc: i18n.import.failedDesc, primary: i18n.ok);
    } finally {
      if (_status == ImportStatus.importing) {
        setState(() {
          _status = ImportStatus.end;
        });
      }
    }
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
