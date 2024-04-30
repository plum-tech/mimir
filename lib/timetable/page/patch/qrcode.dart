import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/design/widgets/card.dart';
import 'package:sit/timetable/entity/timetable.dart';
import 'package:sit/timetable/page/patch/patch.dart';
import 'package:sit/timetable/page/preview.dart';
import 'package:text_scroll/text_scroll.dart';

import '../../i18n.dart';
import '../../entity/patch.dart';
import '../../init.dart';
import '../mine.dart';

Future<void> onTimetablePatchFromQrCode({
  required BuildContext context,
  required TimetablePatchEntry patch,
}) async {
  await context.showSheet((ctx) => TimetablePatchFromQrCodeSheet(patch: patch));
}

class TimetablePatchFromQrCodeSheet extends ConsumerStatefulWidget {
  final TimetablePatchEntry patch;

  const TimetablePatchFromQrCodeSheet({
    super.key,
    required this.patch,
  });

  @override
  ConsumerState<TimetablePatchFromQrCodeSheet> createState() => _TimetablePatchFromQrCodeSheetState();
}

class _TimetablePatchFromQrCodeSheetState extends ConsumerState<TimetablePatchFromQrCodeSheet> {
  @override
  Widget build(BuildContext context) {
    final storage = TimetableInit.storage.timetable;
    final timetables = ref.watch(storage.$rows);
    final patch = widget.patch;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: patch is TimetablePatchSet
                ? [
                    const Icon(Icons.dashboard_customize).padOnly(r: 8),
                    TextScroll(patch.name).expanded(),
                  ].row()
                : i18n.patch.title.text(),
            actions: [
              PlatformTextButton(
                onPressed: timetables.isEmpty
                    ? null
                    : () async {
                        final timetable = await context.showSheet<SitTimetable>(
                          (context) => TimetablePatchUseSheet(patch: patch),
                        );
                        if (timetable == null) return;
                        if (!context.mounted) return;
                        context.pop();
                      },
                child: i18n.use.text(),
              )
            ],
          ),
          if (patch is TimetablePatchSet)
            SliverList.builder(
              itemCount: patch.patches.length,
              itemBuilder: (ctx, i) {
                final p = patch.patches[i];
                return ReadonlyTimetablePatchEntryWidget(
                  entry: p,
                  enableQrCode: false,
                );
              },
            )
          else
            SliverList.list(children: [
              ReadonlyTimetablePatchEntryWidget(
                entry: patch,
                enableQrCode: false,
              )
            ]),
        ],
      ),
    );
  }
}

class TimetablePatchUseSheet extends ConsumerStatefulWidget {
  final TimetablePatchEntry patch;

  const TimetablePatchUseSheet({
    super.key,
    required this.patch,
  });

  @override
  ConsumerState<TimetablePatchUseSheet> createState() => _TimetablePatchUseSheetState();
}

class _TimetablePatchUseSheetState extends ConsumerState<TimetablePatchUseSheet> {
  @override
  Widget build(BuildContext context) {
    final storage = TimetableInit.storage.timetable;
    final timetables = ref.watch(storage.$rows);
    assert(timetables.isNotEmpty);
    final patch = widget.patch;
    timetables.sort((a, b) => b.row.lastModified.compareTo(a.row.lastModified));
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.medium(
            title: i18n.mine.title.text(),
          ),
          SliverList.builder(
            itemCount: timetables.length,
            itemBuilder: (ctx, i) {
              final (:id, row: timetable) = timetables[i];
              return TimetablePatchReceiverCard(
                id: id,
                timetable: timetable,
                onAdded: () {
                  final newTimetable = buildTimetable(timetable, patch).markModified();
                  storage[id] = newTimetable;
                  ctx.pop(newTimetable);
                },
                onPreview: () async {
                  await previewTimetable(
                    context,
                    timetable: buildTimetable(timetable, patch),
                  );
                },
              ).padH(6);
            },
          ),
        ],
      ),
    );
  }

  SitTimetable buildTimetable(SitTimetable timetable, TimetablePatchEntry patch) {
    return timetable.copyWith(
      patches: List.of(timetable.patches)..add(patch),
    );
  }
}

class TimetablePatchReceiverCard extends StatelessWidget {
  final int id;
  final SitTimetable timetable;
  final VoidCallback? onAdded;
  final VoidCallback? onPreview;

  const TimetablePatchReceiverCard({
    super.key,
    required this.id,
    required this.timetable,
    this.onAdded,
    this.onPreview,
  });

  @override
  Widget build(BuildContext context) {
    final onAdded = this.onAdded;
    final onPreview = this.onPreview;
    return [
      TimetableInfo(timetable: timetable),
      OverflowBar(
        children: [
          [
            if (onAdded != null)
              FilledButton(
                onPressed: onAdded,
                child: i18n.add.text(),
              ),
            if (onPreview != null)
              OutlinedButton(
                onPressed: onPreview,
                child: i18n.preview.text(),
              ),
          ].wrap(spacing: 4),
        ],
      ),
    ].column(caa: CrossAxisAlignment.start).padSymmetric(v: 10, h: 15).inOutlinedCard();
  }
}
