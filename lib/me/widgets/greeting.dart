import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mimir/credential/widgets/oa_scope.dart';
import 'package:mimir/entity/campus.dart';
import 'package:mimir/l10n/common.dart';
import 'package:mimir/hive/settings.dart';
import 'package:mimir/utils/timer.dart';
import 'package:rettulf/rettulf.dart';

class Greeting extends StatefulWidget {
  const Greeting({super.key});

  @override
  State<StatefulWidget> createState() => _GreetingState();
}

class _GreetingState extends State<Greeting> {
  int? studyDays;
  Campus campus = Settings.campus;

  Timer? dayWatcher;
  DateTime? _admissionDate;

  @override
  void initState() {
    super.initState();

    /// Rebuild the study days when date is changed.
    dayWatcher = runPeriodically(const Duration(minutes: 1), (timer) {
      final admissionDate = _admissionDate;
      if (admissionDate != null) {
        final now = DateTime.now();
        setState(() {
          studyDays = now.difference(admissionDate).inDays;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    // 如果用户不是新生或老师，那么就显示学习天数
    if (context.auth.credential != null) {
      setState(() {
        studyDays = _getStudyDaysAndInitState();
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    dayWatcher?.cancel();
  }

  int _getStudyDaysAndInitState() {
    final oaCredential = context.auth.credential;
    if (oaCredential != null) {
      final id = oaCredential.account;

      if (id.isNotEmpty) {
        final admissionYearTrailing = int.tryParse(id.substring(0, 2));
        if (admissionYearTrailing != null) {
          int admissionYear = 2000 + admissionYearTrailing;
          final admissionDate = DateTime(admissionYear, 9, 1);
          _admissionDate = admissionDate;

          /// 计算入学时间, 默认按 9 月 1 日开学来算. 年份 admissionYear 是完整的年份, 如 2018.
          return DateTime.now().difference(admissionDate).inDays;
        }
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final days = studyDays;
    return ListTile(
      titleTextStyle:context.textTheme.titleMedium,
      title: _i18n.headerA.text(),
      subtitleTextStyle: context.textTheme.headlineSmall,
      subtitle: _i18n.headerB((days ?? 0) + 1).text(),
    );
  }
}

const _i18n = _I18n();

class _I18n {
  const _I18n();

  static const ns = "greeting";

  final campus = const CampusI10n();

  String get headerA => "$ns.headerA".tr();

  String headerB(int day) => "$ns.headerB".plural(day, args: [day.toString()]);
}
