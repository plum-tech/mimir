import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/service.dart';
import '../page/details.dart';

const List<Color> _serviceColors = <Color>[
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

class YwbServiceTile extends StatelessWidget {
  final YwbService meta;
  final bool isHot;

  const YwbServiceTile({super.key, required this.meta, required this.isHot});

  @override
  Widget build(BuildContext context) {
    final colorIndex = Random(meta.id.hashCode).nextInt(_serviceColors.length);
    final color = _serviceColors[colorIndex];
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
        context.navigator.push(MaterialPageRoute(builder: (_) => YwbServiceDetailsPage(meta: meta)));
      },
    );
  }
}
