import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/menu.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/qrcode/page/view.dart';
import 'package:sit/qrcode/utils.dart';
import 'package:sit/settings/dev.dart';
import 'package:sit/timetable/entity/pos.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../entity/loc.dart';
import '../../entity/patch.dart';
import '../../entity/timetable.dart';
import '../../i18n.dart';
import '../../page/preview.dart';
import '../../utils.dart';

class TimetableDayLocModeSwitcher extends StatelessWidget {
  final TimetableDayLocMode selected;
  final ValueChanged<TimetableDayLocMode> onSelected;

  const TimetableDayLocModeSwitcher({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TimetableDayLocMode>(
      segments: TimetableDayLocMode.values
          .map((e) => ButtonSegment<TimetableDayLocMode>(
                value: e,
                label: e.l10n().text(),
              ))
          .toList(),
      selected: <TimetableDayLocMode>{selected},
      onSelectionChanged: (newSelection) async {
        onSelected(newSelection.first);
      },
    );
  }
}

class TimetableDayLocPosSelectionTile extends StatelessWidget {
  final Widget title;
  final Widget? leading;
  final TimetablePos? pos;
  final SitTimetable timetable;
  final ValueChanged<TimetablePos>? onChanged;

  const TimetableDayLocPosSelectionTile({
    super.key,
    required this.title,
    this.leading,
    this.pos,
    this.onChanged,
    required this.timetable,
  });

  @override
  Widget build(BuildContext context) {
    final pos = this.pos;
    final onChanged = this.onChanged;
    return ListTile(
      leading: leading,
      title: title,
      subtitle: pos == null ? i18n.unspecified.text() : pos.l10n().text(),
      trailing: onChanged == null
          ? null
          : FilledButton(
              child: i18n.select.text(),
              onPressed: () async {
                final newPos = await selectDayInTimetable(
                  context: context,
                  timetable: timetable,
                  initialPos: pos,
                  submitLabel: i18n.select,
                );
                if (newPos == null) return;
                onChanged(newPos);
              },
            ),
    );
  }
}

final lastInitialDate = StateProvider<DateTime>((ref) => DateTime.now());

class TimetableDayLocDateSelectionTile extends ConsumerWidget {
  final Widget title;
  final Widget? leading;
  final DateTime? date;
  final SitTimetable timetable;
  final ValueChanged<DateTime>? onChanged;

  const TimetableDayLocDateSelectionTile({
    super.key,
    this.leading,
    required this.title,
    this.date,
    this.onChanged,
    required this.timetable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = this.date;
    final onChanged = this.onChanged;
    return ListTile(
      leading: leading,
      title: title,
      subtitle: date == null ? i18n.unspecified.text() : context.formatYmdWeekText(date).text(),
      trailing: onChanged == null
          ? null
          : FilledButton(
              child: i18n.select.text(),
              onPressed: () async {
                final now = DateTime.now();
                final newDate = await showDatePicker(
                  context: context,
                  initialDate: date ?? ref.read(lastInitialDate),
                  currentDate: date,
                  firstDate: DateTime(now.year - 4),
                  lastDate: DateTime(now.year + 2),
                );
                if (newDate == null) return;
                ref.read(lastInitialDate.notifier).state = newDate;
                onChanged(newDate);
              },
            ),
    );
  }
}

class TimetablePatchMenuAction<TPatch extends TimetablePatch> extends StatelessWidget {
  final TPatch patch;
  final SitTimetable timetable;
  final ValueChanged<TPatch>? onChanged;

  const TimetablePatchMenuAction({
    super.key,
    required this.patch,
    required this.timetable,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PullDownMenuButton(itemBuilder: (ctx) {
      return [
        PullDownItem(
          icon: context.icons.preview,
          title: i18n.preview,
          onTap: () async {
            await previewTimetable(context, timetable: timetable);
          },
        ),
        if (!kIsWeb)
          if (Dev.on)
            PullDownItem(
              title: i18n.shareQrCode,
              icon: context.icons.qrcode,
              onTap: () async {
                shareTimetablePatchQrCode(context, patch);
              },
            ),
      ];
    });
  }
}

class TimetablePatchWidget<TPatch extends TimetablePatch> extends StatelessWidget {
  final Widget? leading;
  final TPatch patch;
  final bool selected;
  final SitTimetable timetable;
  final ValueChanged<TPatch>? onChanged;
  final FutureOr<TPatch?> Function(TPatch old) edit;

  const TimetablePatchWidget({
    super.key,
    this.leading,
    required this.patch,
    required this.timetable,
    this.onChanged,
    required this.edit,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final onChanged = this.onChanged;
    return ListTile(
      leading: leading ?? Icon(patch.type.icon),
      title: patch.type.l10n().text(),
      subtitle: patch.l10n().text(),
      selected: selected,
      trailing: TimetablePatchMenuAction(patch: patch, timetable: timetable, onChanged: onChanged),
      onTap: onChanged == null
          ? null
          : () async {
              final newPath = await edit(patch);
              if (newPath == null) return;
              onChanged(newPath);
            },
    );
  }
}

class AddPatchButtons extends StatelessWidget {
  final SitTimetable timetable;
  final void Function(TimetablePatch patch) addPatch;

  const AddPatchButtons({
    super.key,
    required this.timetable,
    required this.addPatch,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(left: 8),
      children: TimetablePatchType.creatable
          .map((type) => ActionChip(
                avatar: Icon(type.icon),
                label: type.l10n().text(),
                onPressed: () async {
                  final patch = await type.create(context, timetable, null);
                  if (patch == null) return;
                  addPatch(patch);
                },
              ).padOnly(r: 8))
          .toList(),
    ).sized(h: 40);
  }
}

void shareTimetablePatchQrCode(BuildContext context, TimetablePatchEntry patch) async {
  if (kIsWeb) return;
  final qrCodeData = Uri(
    scheme: R.scheme,
    path: "timetable-patch",
    query: encodeBytesForUrl(patch.encodeByteList()),
  );
  await context.show$Sheet$(
    (context) => QrCodePage(
      title: TextScroll(switch (patch) {
        TimetablePatchSet() => patch.name,
        TimetablePatch() => patch.l10n(),
      }),
      data: qrCodeData.toString(),
    ),
  );
}
