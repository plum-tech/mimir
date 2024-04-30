import 'package:flutter/widgets.dart';
import 'package:sit/design/adaptive/dialog.dart';
import 'package:sit/design/adaptive/foundation.dart';

import '../../i18n.dart';
import '../../entity/patch.dart';

Future<void> onTimetablePatchFromQrCode({
  required BuildContext context,
  required TimetablePatchEntry patch,
}) async {
  // await HapticFeedback.mediumImpact();
  // if (!context.mounted) return;
  // context.push("/timetable/p13n/custom");
  context.showSheet((ctx)=>TimetablePatchFromQrCodeSheet());
}

class TimetablePatchFromQrCodeSheet extends StatefulWidget {
  const TimetablePatchFromQrCodeSheet({super.key});

  @override
  State<TimetablePatchFromQrCodeSheet> createState() => _TimetablePatchFromQrCodeSheetState();
}

class _TimetablePatchFromQrCodeSheetState extends State<TimetablePatchFromQrCodeSheet> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
