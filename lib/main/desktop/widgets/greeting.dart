import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:mimir/l10n/common.dart';
import 'package:mimir/storage/settings.dart';
import 'package:mimir/utils/timer.dart';

class GreetingWidget extends StatefulWidget {
  const GreetingWidget({super.key});

  @override
  State<StatefulWidget> createState() => _GreetingWidgetState();
}

class _GreetingWidgetState extends State<GreetingWidget> {
  int? studyDays;
  int campus = Settings.campus;

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

  String _getCampusName() {
    if (campus == 1) return _i18n.campus.fengxianDistrict;
    return _i18n.campus.xuhuiDistrict;
  }

  Widget buildAll(BuildContext context) {
    final textStyleSmall = Theme.of(context).textTheme.titleMedium;
    final textStyleLarge = Theme.of(context).textTheme.headlineSmall;
    final days = studyDays;
    final List<Widget> sitDate;
    sitDate = [
      Text(_i18n.headerA, style: textStyleSmall),
      Text(_i18n.headerB((days ?? 0) + 1), style: textStyleLarge),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...sitDate,
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: buildAll(context),
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
