import 'package:flutter/material.dart';
import 'package:mimir/design/widgets/expansion_tile.dart';
import 'package:mimir/l10n/extension.dart';
import 'package:rettulf/rettulf.dart';

import '../entity/application.dart';

class YwbApplicationTile extends StatelessWidget {
  final YwbApplication application;

  const YwbApplicationTile(
    this.application, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedExpansionTile(
      title: "${application.name} #${application.workId}".text(),
      subtitle: context.formatYmdWeekText(application.startTs).text(),
      trailing: const Icon(Icons.keyboard_arrow_down),
      children: application.track.map((e) => YwbApplicationTrackTile(e)).toList(),
    );
  }
}

class YwbApplicationTrackTile extends StatelessWidget {
  final YwbApplicationTrack track;

  const YwbApplicationTrackTile(
    this.track, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: true,
      leading: track.isActionOk
          ? const Icon(Icons.check, color: Colors.green)
          : const Icon(Icons.error_outline, color: Colors.redAccent),
      title: track.step.text(),
      subtitle: [
        context.formatYmdhmNum(track.timestamp).text(),
        if (track.message.isNotEmpty) track.message.text(),
        track.action.text(),
      ].column(caa: CrossAxisAlignment.start),
      trailing: track.senderName.text(),
    );
  }
}

// final String resultUrl =
//     'https://xgfy.sit.edu.cn/unifri-flow/WF/mobile/index.html?ismobile=1&FK_Flow=${msg.functionId}&WorkID=${msg.workId}&IsReadonly=1&IsView=1';
// Navigator.of(context)
//     .push(MaterialPageRoute(builder: (_) => YwbInAppViewPage(title: msg.name, url: resultUrl)));
