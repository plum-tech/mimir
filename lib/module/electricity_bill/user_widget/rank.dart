import 'package:flutter/material.dart';

import '../../activity/using.dart';
import '../entity/account.dart';
import 'card.dart';

class RankView extends StatefulWidget {
  const RankView({super.key});

  @override
  RankViewState createState() => RankViewState();
}

class RankViewState extends State<RankView> {
  Rank? curRank;

  @override
  Widget build(BuildContext context) {
    return buildCard(i18n.elecBillRank, _buildRankContent(context));
  }

  Widget _buildRank(BuildContext ctx) {
    final rank = curRank;
    if (rank == null) {
      return Placeholders.loading();
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            i18n.elecBill24hBill(rank.consumption.toStringAsFixed(2)),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(i18n.elecBillRankAbove(((1.0 - rank.rank / rank.roomCount) * 100).toStringAsFixed(2)))
        ],
      );
    }
  }

  Widget _buildRankContent(BuildContext ctx) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(children: [
          Icon(
            Icons.stacked_bar_chart,
            size: 100,
            color: context.fgColor,
          ),
          Expanded(child: _buildRank(ctx))
        ]));
  }
}
