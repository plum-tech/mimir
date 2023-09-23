import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/application.dart';
import '../page/details.dart';

const List<Color> _applicationColors = <Color>[
  Colors.orangeAccent,
  Colors.redAccent,
  Colors.blueAccent,
  Colors.grey,
  Colors.green,
  Colors.yellowAccent,
  Colors.cyan,
  Colors.purple,
  Colors.teal,
];

class ApplicationTile extends StatelessWidget {
  final YwbApplicationMeta meta;
  final bool isHot;

  const ApplicationTile({super.key, required this.meta, required this.isHot});

  @override
  Widget build(BuildContext context) {
    final colorIndex = Random(meta.id.hashCode).nextInt(_applicationColors.length);
    final color = _applicationColors[colorIndex];
    final style = context.textTheme.bodyMedium;
    final views = isHot
        ? [
            Text(meta.count.toString(), style: style),
            const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.red,
            ),
          ].row(mas: MainAxisSize.min)
        : Text(meta.count.toString(), style: style);

    return ListTile(
      leading: Icon(meta.icon, size: 35, color: color).center().sized(w: 40, h: 40),
      title: Text(
        meta.name,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        meta.summary,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: views,
      onTap: () {
        // TODO: details page
        context.navigator.push(MaterialPageRoute(builder: (_) => YwbApplicationDetailsPage(meta: meta)));
      },
    );
  }
}
