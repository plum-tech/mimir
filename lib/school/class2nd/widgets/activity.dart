import 'package:flutter/material.dart';
import 'package:mimir/design/adaptive/adaptive.dart';
import 'package:mimir/design/colors.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/list.dart';
import '../page/detail.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;

  const ActivityCard(this.activity, {super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(16), child: _buildBasicInfo(context))
        .inCard(margin: const EdgeInsets.all(10))
        .hero(activity.id)
        .on(tap: () {
      final route = context.adaptive.makeRoute((_) => DetailPage(activity, hero: activity.id));
      context.navigator.push(route);
    });
  }

  Widget _buildBasicInfo(BuildContext ctx) {
    final titleStyle = ctx.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500);
    final tagsStyle = ctx.textTheme.titleSmall;
    final subtitleStyle = ctx.textTheme.bodySmall?.copyWith(color: Colors.grey);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        activity.realTitle
            .text(
              style: titleStyle,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            )
            .padSymmetric(h: 12),
        Container(
          decoration: BoxDecoration(color: ctx.bgColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                activity.tags.join(" ").text(style: tagsStyle, maxLines: 2, overflow: TextOverflow.clip),
                ctx
                    .formatYmdNum(activity.ts)
                    .text(style: subtitleStyle, overflow: TextOverflow.clip)
                    .align(at: Alignment.centerRight)
                    .padOnly(r: 8),
              ],
            ).align(at: Alignment.bottomCenter),
          ),
        ),
      ],
    );
  }
}
