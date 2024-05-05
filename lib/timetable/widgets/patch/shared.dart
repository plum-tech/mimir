import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/adaptive/menu.dart';
import 'package:sit/design/adaptive/multiplatform.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/qrcode/page/view.dart';
import 'package:sit/timetable/entity/pos.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../entity/loc.dart';
import '../../entity/patch.dart';
import '../../entity/timetable.dart';
import '../../i18n.dart';
import '../../page/preview.dart';
import '../../qrcode/patch.dart';
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
const _kOutOfRangeColor = Colors.yellow;

class PatchOutOfRangeWarningTile extends StatelessWidget {
  const PatchOutOfRangeWarningTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        context.icons.warning,
        color: _kOutOfRangeColor,
      ),
      title: i18n.patch.dateOutOfRangeTip.text(
        style: const TextStyle(color: _kOutOfRangeColor),
      ),
    );
  }
}

class _TimetableDayLocSelectionTileBase extends StatelessWidget {
  final String title;
  final IconData? icon;
  final TimetableDayLoc? loc;
  final SitTimetable timetable;
  final VoidCallback? onSelected;

  const _TimetableDayLocSelectionTileBase({
    this.icon,
    required this.title,
    this.loc,
    this.onSelected,
    required this.timetable,
  });

  @override
  Widget build(BuildContext context) {
    final loc = this.loc;
    final onSelected = this.onSelected;
    var inRange = true;
    if (loc != null && loc.mode == TimetableDayLocMode.date) {
      inRange = timetable.inRange(loc.date);
    }
    return ListTile(
      leading: icon != null
          ? Icon(
              icon,
              color: inRange ? null : _kOutOfRangeColor,
            )
          : null,
      title: title.text(
        style: inRange ? null : const TextStyle(color: _kOutOfRangeColor),
      ),
      subtitle: (loc == null
              ? i18n.unspecified
              : loc.mode == TimetableDayLocMode.pos
                  ? loc.pos.l10n()
                  : context.formatYmdWeekText(loc.date))
          .text(
        style: inRange ? null : const TextStyle(color: _kOutOfRangeColor),
      ),
      trailing: onSelected == null
          ? null
          : FilledButton(
              onPressed: onSelected,
              child: i18n.select.text(),
            ),
    );
  }
}

class TimetableDayLocPosSelectionTile extends StatelessWidget {
  final String title;
  final IconData? icon;
  final TimetablePos? pos;
  final SitTimetable timetable;
  final ValueChanged<TimetablePos>? onChanged;

  const TimetableDayLocPosSelectionTile({
    super.key,
    required this.title,
    this.icon,
    this.pos,
    this.onChanged,
    required this.timetable,
  });

  @override
  Widget build(BuildContext context) {
    final pos = this.pos;
    final onChanged = this.onChanged;
    return _TimetableDayLocSelectionTileBase(
      title: title,
      icon: icon,
      loc: pos == null ? null : TimetableDayLoc.pos(pos),
      timetable: timetable,
      onSelected: onChanged == null
          ? null
          : () async {
              final newPos = await selectDayInTimetable(
                context: context,
                timetable: timetable,
                initialPos: pos,
                submitLabel: i18n.select,
              );
              if (newPos == null) return;
              onChanged(newPos);
            },
    );
  }
}

final lastInitialDate = StateProvider<DateTime>((ref) => DateTime.now());

class TimetableDayLocDateSelectionTile extends ConsumerWidget {
  final String title;
  final IconData? icon;
  final DateTime? date;
  final SitTimetable timetable;
  final ValueChanged<DateTime>? onChanged;

  const TimetableDayLocDateSelectionTile({
    super.key,
    required this.title,
    this.icon,
    this.date,
    this.onChanged,
    required this.timetable,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = this.date;
    final onChanged = this.onChanged;
    return _TimetableDayLocSelectionTileBase(
      title: title,
      icon: icon,
      loc: date == null ? null : TimetableDayLoc.date(date),
      timetable: timetable,
      onSelected: onChanged == null
          ? null
          : () async {
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
    );
  }
}

class TimetablePatchMenuAction<TPatch extends TimetablePatch> extends StatelessWidget {
  final TPatch patch;
  final SitTimetable? timetable;
  final VoidCallback? onEdit;
  final bool enableQrCode;
  final VoidCallback? onDeleted;

  const TimetablePatchMenuAction({
    super.key,
    required this.patch,
    this.timetable,
    this.onEdit,
    this.enableQrCode = true,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    final onDeleted = this.onDeleted;
    final timetable = this.timetable;
    return PullDownMenuButton(itemBuilder: (ctx) {
      return [
        if (timetable != null)
          PullDownItem(
            icon: context.icons.preview,
            title: i18n.preview,
            onTap: () async {
              await previewTimetable(context, timetable: timetable);
            },
          ),
        if (!kIsWeb && enableQrCode)
          PullDownItem(
            title: i18n.shareQrCode,
            icon: context.icons.qrcode,
            onTap: () async {
              shareTimetablePatchQrCode(context, patch);
            },
          ),
        if (onDeleted != null)
          PullDownItem.delete(
            icon: context.icons.delete,
            title: i18n.delete,
            onTap: onDeleted,
          ),
      ];
    });
  }
}

class TimetablePatchWidget<TPatch extends TimetablePatch> extends StatelessWidget {
  final Widget Function(BuildContext context, Widget child)? leading;
  final TPatch patch;
  final bool optimizedForTouch;
  final VoidCallback? onDeleted;
  final bool selected;
  final SitTimetable? timetable;
  final VoidCallback? onEdit;
  final bool enableQrCode;

  const TimetablePatchWidget({
    super.key,
    this.leading,
    required this.patch,
    this.timetable,
    this.onEdit,
    this.optimizedForTouch = false,
    this.selected = false,
    this.enableQrCode = true,
    this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: leading?.call(
              context,
              buildLeading(context),
            ) ??
            buildLeading(context),
        title: patch.type.l10n().text(),
        subtitle: patch.l10n().text(),
        selected: selected,
        trailing: TimetablePatchMenuAction(
          patch: patch,
          timetable: timetable,
          onEdit: onEdit,
          onDeleted: onDeleted,
          enableQrCode: enableQrCode,
        ),
        onTap: onEdit);
  }

  Widget buildLeading(BuildContext context) {
    return PatchIcon(
      icon: patch.type.icon,
      optimizedForTouch: optimizedForTouch,
    );
  }
}

class PatchIcon extends StatelessWidget {
  final IconData icon;
  final bool optimizedForTouch;
  final bool inCard;

  const PatchIcon({
    super.key,
    required this.icon,
    this.optimizedForTouch = false,
    this.inCard = true,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Icon(
      icon,
      size: optimizedForTouch ? context.theme.iconTheme.size ?? 24 * 1.25 : null,
    ).padAll(8);
    if (inCard) {
      return Card.filled(
        margin: EdgeInsets.zero,
        child: widget,
      );
    } else {
      return widget;
    }
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
  final qrCodeData = const TimetablePatchDeepLink().encode(patch);
  await context.showSheet(
    (context) => QrCodePage(
      title: TextScroll(switch (patch) {
        TimetablePatchSet() => patch.name,
        TimetablePatch() => patch.l10n(),
      }),
      data: qrCodeData.toString(),
    ),
  );
}
