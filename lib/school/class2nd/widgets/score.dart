import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';
import 'package:sit/design/adaptive/foundation.dart';
import 'package:sit/l10n/extension.dart';
import 'package:sit/school/class2nd/entity/attended.dart';
import '../i18n.dart';

class Class2ndScoreTile extends StatelessWidget {
  final Class2ndScoreItem score;

  const Class2ndScoreTile(
    this.score, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final time = score.time;
    final subtitle = time == null ? null : context.formatYmdhmNum(time).text();
    if (score.points != 0 && score.honestyPoints != 0) {
      return ListTile(
        titleTextStyle: context.textTheme.bodyLarge?.copyWith(color: _pointsColor(context, score.points)),
        title:
            "${score.category.l10nName()} ${_pointsText(score.points)}, ${i18n.attended.honestyPoints} ${_pointsText(score.honestyPoints)}"
                .text(),
        subtitle: subtitle,
      );
    } else if (score.points != 0) {
      return ListTile(
        titleTextStyle: context.textTheme.bodyLarge?.copyWith(color: _pointsColor(context, score.points)),
        title: "${score.category.l10nName()} ${_pointsText(score.points)}".text(),
        subtitle: subtitle,
      );
    } else if (score.honestyPoints != 0) {
      return ListTile(
        titleTextStyle: context.textTheme.bodyLarge?.copyWith(color: _pointsColor(context, score.honestyPoints)),
        title: "${i18n.attended.honestyPoints} ${_pointsText(score.honestyPoints)}".text(),
        subtitle: subtitle,
      );
    } else {
      return ListTile(
        title: "".text(),
        subtitle: subtitle,
      );
    }
  }
}

String _pointsText(double points) {
  if (points > 0) {
    return "+${points.toStringAsFixed(2)}";
  } else if (points == 0) {
    return "+0";
  } else {
    return points.toStringAsFixed(2);
  }
}

Color? _pointsColor(BuildContext ctx, double points) {
  if (points > 0) {
    return Colors.green;
  } else if (points == 0) {
    return null;
  } else {
    return ctx.$red$;
  }
}
