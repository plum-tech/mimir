import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mimir/design/adaptive/foundation.dart';
import 'package:mimir/design/adaptive/multiplatform.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/patch.dart';
import '../page/patch_set.dart';
import '../page/qrcode.dart';
import '../../i18n.dart';

class TimetablePatchSetGalleryCard extends StatelessWidget {
  final TimetablePatchSet patchSet;
  final VoidCallback onAdd;

  const TimetablePatchSetGalleryCard({
    super.key,
    required this.patchSet,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return [
      ListTile(
        isThreeLine: true,
        title: patchSet.name.text(),
        subtitle: TimetablePatchSetPatchesPreview(patchSet),
        trailing: IconButton.filledTonal(
          onPressed: onAdd,
          icon: Icon(context.icons.add),
        ),
        onTap: () async {
          await context.showSheet(
            (ctx) => TimetablePatchViewerPage(
              patch: patchSet,
              actions: [
                PlatformTextButton(
                  onPressed: () {
                    ctx.pop();
                    onAdd();
                  },
                  child: i18n.add.text(),
                )
              ],
            ),
          );
        },
      ),
    ].column().inOutlinedCard(clip: Clip.hardEdge);
  }
}
