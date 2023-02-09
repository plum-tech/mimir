import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mimir/credential/symbol.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:mimir/module/simple_page/page/weather.dart';
import 'package:mimir/storage/init.dart';

class GreetingWidget extends StatefulWidget {
  const GreetingWidget({super.key});

  @override
  State<StatefulWidget> createState() => _GreetingWidgetState();
}

class _GreetingWidgetState extends State<GreetingWidget> {
  int? studyDays;
  int campus = Kv.home.campus;

  Timer? dayWatcher;
  DateTime? _admissionDate;

  @override
  void initState() {
    super.initState();
    // 如果用户不是新生或老师，那么就显示学习天数
    if (Auth.oaCredential != null) {
      setState(() {
        studyDays = _getStudyDaysAndInitState();
      });
    }

    /// Rebuild the study days when date is changed.
    dayWatcher = Timer.periodic(const Duration(minutes: 1), (timer) {
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
  void dispose() {
    super.dispose();
    dayWatcher?.cancel();
  }

  int _getStudyDaysAndInitState() {
    final oaCredential = Auth.oaCredential;
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
    if (campus == 1) return i18n.fengxianDistrict;
    return i18n.xuhuiDistrict;
  }

  Widget buildAll(BuildContext context) {
    final textStyleSmall = Theme.of(context).textTheme.headline6?.copyWith(
          color: Colors.white60,
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        );
    final textStyleLarge = Theme.of(context)
        .textTheme
        .titleLarge
        ?.copyWith(color: Colors.white70, fontSize: 24.0, fontWeight: FontWeight.w700);
    final textStyleWeather = Theme.of(context).textTheme.subtitle1?.copyWith(
          color: Colors.white70,
          fontSize: 19.0,
          fontWeight: FontWeight.w500,
        );
    final days = studyDays;
    final List<Widget> sitDate;
    if (days == null) {
      sitDate = [
        Text(i18n.greetingHeader0L1, style: textStyleSmall),
      ];
    } else {
      if (days <= 0) {
        sitDate = [
          Text(i18n.greetingHeader0L1, style: textStyleSmall),
          Text(i18n.greetingHeader0L2, style: textStyleLarge),
        ];
      } else {
        sitDate = [
          Text(i18n.greetingHeaderL1, style: textStyleSmall),
          Text(i18n.greetingHeaderL2(yOrNo(i18n.greetingHeaderEnableIncrement) ? days + 1 : days),
              style: textStyleLarge),
        ];
      }
    }
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
