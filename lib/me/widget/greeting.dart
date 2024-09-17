import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mimir/credentials/entity/credential.dart';
import 'package:mimir/credentials/init.dart';
import 'package:mimir/l10n/common.dart';
import 'package:mimir/utils/timer.dart';
import 'package:rettulf/rettulf.dart';

class Greeting extends ConsumerStatefulWidget {
  const Greeting({super.key});

  @override
  ConsumerState<Greeting> createState() => _GreetingState();
}

class _GreetingState extends ConsumerState<Greeting> {
  Timer? dayWatcher;
  DateTime? _admissionDate;

  @override
  void initState() {
    super.initState();

    /// Rebuild the study days when date is changed.
    dayWatcher = runPeriodically(const Duration(minutes: 1), (timer) {
      final admissionDate = _admissionDate;
      if (admissionDate != null) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    dayWatcher?.cancel();
    super.dispose();
  }

  int _getStudyDaysAndInitState(Credential credentials) {
    final id = credentials.account;
    if (id.isNotEmpty) {
      final admissionYearTrailing = int.tryParse(id.substring(0, 2));
      if (admissionYearTrailing != null) {
        int admissionYear = 2000 + admissionYearTrailing;
        final admissionDate = DateTime(admissionYear, 9, 1);
        _admissionDate = admissionDate;

        /// To calculate admission year after 2000, the default start date is September 1st.
        /// e.g. 2018.
        return DateTime.now().difference(admissionDate).inDays;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final credentials = ref.watch(CredentialsInit.storage.oa.$credentials);
    final studyDays = credentials == null ? 0 : _getStudyDaysAndInitState(credentials);

    final days = studyDays;
    return [
      _i18n.headerA.text(style: context.textTheme.titleMedium),
      _i18n.headerB((days) + 1).text(style: context.textTheme.headlineSmall),
    ].column(mas: MainAxisSize.min, caa: CrossAxisAlignment.start);
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
